class OrderInfomationsController < RoleApplicationController
  include Commons::Common
  include Commons::ValidateCommon

  before_action :load_per_page_params, :current_per_page, only: :index
  before_action :load_orders, only: [:index, :export]
  before_action :load_params_download, only: [:download, :download_data]

  def index
    @text_search = params['q']['ticket_number_or_osi_ca_or_osi_booker_cont'] rescue ''
    @q = @orders.ransack(params[:q])
    result = @q.result.page(params[:page])
    @orders = @current_per_page == Settings.item_paging_all ? result.per(@orders.count) : result.per(@current_per_page)
  end

  def import
    @errors = []
    return @errors << 'Please choose xlsx file.' if params[:file] == Settings.undefined

    check_file_type_excel(params[:file])
    array_data = read_excel_file(params[:file].path)
    return @errors << 'File import includes 15 columns. Please check file again!' if array_data.first&.size.to_i != 15

    data = []
    osi_cas = OsiCa.all.pluck(:code)
    osi_bookers = OsiBooker.all.pluck(:code)

    array_data.each.with_index(1) do |row, index|
      break @errors << "Row #{index + 1}: Osi Ca not exists" if row[10].present? && !osi_cas.include?(row[10].to_s)
      break @errors << "Row #{index + 1}: Osi Booker not exists" if row[11].present? && !osi_bookers.include?(row[11].to_s)

      issue_date = row[0].to_date rescue nil
      type_ticket = row[5]
      break @errors << "Row #{index + 1}: Issue Date not exists" if issue_date.nil?

      flt_date = row[1].to_date
      issue_date_year = issue_date.year
      flt_date = flt_date.change(year: issue_date_year)
      case type_ticket
      when 'S'
        flt_date = flt_date.change(year: issue_date_year + 1) if flt_date < issue_date
      else
        flt_date = flt_date.change(year: issue_date_year - 1) if flt_date < issue_date
      end
      data << { issue_date: row[0], flt_date: flt_date, ticket_number: row[2], pax_name: row[3], route: row[4],
                type_ticket: row[5], pnr: row[6], coupon_status: row[7], class_ticket: row[8], ag: row[9],
                osi_ca: row[10], osi_booker: row[11], fare: (row[12].to_i).abs, charge: (row[13].to_i).abs, saler: row[14],
                nat_amt: (row[12].to_i).abs + (row[13].to_i).abs
              }
    end
    return if @errors.present?

    OrderInfomation.transaction do
      OrderInfomation.upsert_all(data)
      tracking = TrackingHistory.find_or_initialize_by(date_tracking: Date.current, user_id: current_user.id)
      content = "#{params[:file].original_filename}"
      tracking.tracking_history_details.build(action_submit: "Import Excel !!!", content: content)
      tracking.save
      osi_cas = OsiCa.all.pluck(:code, :limit_value).to_h
      order_infomations = OrderInfomation.total_by_osi_ca
      order_infomations.each do |osi|
        osi_ca = osi_cas[osi.osi_ca]
        next if osi_ca.blank?

        if osi_ca.to_i < osi.total_value.to_i
          raise StandardError, "OSI #{osi.osi_ca}: #{osi.total_value.to_i} limit value exceeded."
        end
      end
    rescue StandardError => e
      @errors << e.message
      raise ActiveRecord::Rollback
    end
    return if @errors.present?

    # @success = ['The import was successful !!!']
  rescue StandardError => e
    @errors << e.message
  end

  def download; end

  def download_data
    @errors = []
    orders = OrderInfomation.all.order(:issue_date).order_by_class
    if params[:month_issue_date].present?
      orders = orders.by_month(params[:month_issue_date])
    end

    if params[:year_issue_date].present?
      orders = orders.by_year(params[:year_issue_date])
    end

    if params[:month_flt_date].present?
      orders = orders.by_month_flt(params[:month_flt_date])
    end

    if params[:year_flt_date].present?
      orders = orders.by_year_flt(params[:year_flt_date])
    end

    if params[:osi_ca].present?
      hash_osi_cas = OsiCa.all.map { |osi| [osi.id, osi.code] }.to_h
      osi_ca_name = params[:osi_ca].map { |osi| hash_osi_cas[osi.to_i] }
      orders = orders.where(osi_ca: osi_ca_name)
    end

    if params[:osi_booker].present?
      hash_osi_booker = OsiBooker.all.map { |osi| [osi.id, osi.code] }.to_h
      osi_booker_name = params[:osi_ca].map { |osi| hash_osi_booker[osi.to_i] }
      orders = orders.where(osi_ca: osi_booker_name)
    end
    path = "#{Rails.root}/tmp/excel"
    origin_name = "#{current_user.id}_my_sheet.xlsx"
    FileUtils.mkdir_p(path) unless File.directory?(path)
    file_path = "#{path}/#{origin_name}"
    File.delete(file_path) if File.exists?(file_path)
    if load_export_excel(file_path, orders) == :no_error
      @filename = "OSI_#{Time.now.strftime("%Y%m%d")}.xlsx"
      send_file(file_path,
                type: "text/xlsx; charset=utf-8; header=present",
                filename: @filename)
    else
      @errors << 'Cannot export Excel'
      render :download
    end
  end

  def export
    path = "#{Rails.root}/tmp/excel"
    FileUtils.mkdir_p(path) unless File.directory?(path)
    file_path = "#{path}/#{current_user.id}_my_sheet.xlsx"
    File.delete(file_path) if File.exists?(file_path)
    if load_export_excel(file_path, @orders) == :no_error
      filename = "OSI_#{Time.now.strftime("%Y%m%d")}.xlsx"
      send_file(file_path,
                type: "text/xlsx; charset=utf-8; header=present",
                filename: filename)
    else
      redirect_to order_infomations_path, danger: "Cannot export Excel"
    end
  rescue StandardError => e
    redirect_to order_infomations_path, danger: "Cannot export Excel"
  end

  def ajax_download_data
    path = "#{Rails.root}/tmp/excel"
  end

  def delete_order
    ids = JSON.parse(params['ids']).compact
    OrderInfomation.where(id: ids).delete_all
    render js: 'window.location.reload();'
  end

  def update_order
    @errors = []
    osi_cas = OsiCa.all.pluck(:code)
    osi_bookers = OsiBooker.all.pluck(:code)

    if params[:flt_date].present?
      flt_date = Date.parse(params[:flt_date]) rescue nil
      @errors << "Ticket Number #{params[:ticket_number]}: FLT Date is invalid" if flt_date.nil?
    end

    if params[:osi_ca].present? && !osi_cas.include?(params[:osi_ca].to_s)
      @errors << "Ticket Number #{params[:ticket_number]}: Osi Ca not exists"
    end
    if params[:osi_booker].present? && !osi_bookers.include?(params[:osi_booker].to_s)
      @errors << "Ticket Number #{params[:ticket_number]}: Osi Booker not exists"
    end
    return if @errors.present?

    OrderInfomation.transaction do
      order = OrderInfomation.find_by(id: params[:osi_id])
      return unless order.present?

      order.attributes = { flt_date: flt_date, ag: params[:ag], osi_ca: params[:osi_ca], osi_booker: params[:osi_booker],
                           coupon_status: params[:coupon_status]}
      order.save
      changes = order.previous_changes
      if changes.present?
        tracking = TrackingHistory.find_or_initialize_by(date_tracking: Date.current, user_id: current_user.id)
        changes.each do |key, value|
          next if ['updated_at', 'created_at'].include?(key)

          content = "#{Settings.attribute_change.send(key)} updated #{value[0]} => #{value[1]}"
          tracking.tracking_history_details.build(action_submit: "Update Order #{params[:ticket_number]}", content: content)
        end
        tracking.save
      end
      osi_cas = OsiCa.all.pluck(:code, :limit_value).to_h
      order_infomations = OrderInfomation.total_by_osi_ca
      order_infomations.each do |osi|
        osi_ca = osi_cas[osi.osi_ca]
        next if osi_ca.blank?

        if osi_ca.to_i < osi.total_value.to_i
          raise StandardError, "OSI #{osi.osi_ca}: #{osi.total_value.to_i} limit value exceeded."
        end
      end
    rescue StandardError => e
      @errors << e.message
      raise ActiveRecord::Rollback
    end
    return if @errors.present?
    # @orders = OrderInfomation.all
    # @text_search = params['q']['ticket_number_or_osi_ca_or_osi_booker_cont'] rescue ''
    # @q = @orders.ransack(params[:q])
    # result = @q.result.page(params[:page])
    # @orders = @current_per_page == Settings.item_paging_all ? result.per(@orders.count) : result.per(@current_per_page)
    # flash[:success] = 'Orders were updated!'
    # @success = ['Order was updated!!!']
  end

  private

  def load_params_download
    @month_export = OrderInfomation.get_month.distinct.map { |e| [e.month, e.month] }.sort
    @year_export  = OrderInfomation.get_year.distinct.map { |e| [e.year, e.year] }.sort
    @month_flt    = OrderInfomation.get_month_flt.distinct.map { |e| [e.month, e.month] }.sort
    @year_flt     = OrderInfomation.get_year_flt.distinct.map { |e| [e.year, e.year] }.sort
    @osi_cas = OsiCa.all.map { |osi| [osi.name, osi.id] }
    @osi_bookers = OsiBooker.all.map { |osi| [osi.name, osi.id] }
  end

  def load_orders
    @orders = OrderInfomation.order(:issue_date).order_by_class.accessible_by(current_ability)
  end

  def read_excel_file(file_path)
    data = []
    file_data = Roo::Spreadsheet.open(file_path)
    file_data.last_row.times.each do |index|
      next if index + 1 < 2

      row_data = file_data.row(index + 1).map do |e|
        if e.is_a?(String)
          e = e.strip
        end
        e
      end
      data << row_data
    end
    data
  end

  def load_export_excel(file_path, orders)
    workbook = FastExcel.open(file_path)
    worksheet = workbook.add_worksheet

    bold = workbook.add_format(bold: true, border: :border_thin)

    worksheet.append_row(['Issue date', 'FLT Date', 'Ticket Nbr', 'Pax Name', 'Route', 'T', 'PNR', 'Coupon status', 'Class',
                          'AG', 'OSI CA', 'OSI BOOKER', 'Fare', 'Charge', 'Saler'], bold)
    orders.each do |order|
      row = [order.issue_date&.strftime("%d/%m/%Y"), order.flt_date&.strftime("%d/%m/%Y"), order.ticket_number, order.pax_name, order.route, order.type_ticket, order.pnr, order.coupon_status,
            order.class_ticket, order.ag, order.osi_ca, order.osi_booker, order.fare, order.charge, order.saler]
      worksheet.append_row(row)
    end
    workbook.close
  end
end

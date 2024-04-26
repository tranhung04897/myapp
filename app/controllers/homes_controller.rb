class HomesController < ApplicationController
  def dashboard
    orders = OrderInfomation.all
    @total_order = orders.count
    @total = orders.sum(&:nat_amt)
    @total_not_add = orders.where(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_added = orders.where.not(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_by_booker = orders.where.not(osi_booker: [nil, '']).sum(&:nat_amt)
    # orders_osi = orders.group_by(&:osi_ca)
    # @osi_labels = orders_osi.keys.map { |osi| osi.blank? ? 'No Osi' : osi_cas[osi] }
    # @osi_values = orders_osi.values.map { |osis| osis.sum(&:nat_amt) }
    # @data_chart = [@total_added, @total_not_add]

    # orders_osi_booker = orders.group_by(&:osi_booker)
    # osi_bookers = OsiBooker.pluck(:code, :name).to_h
    # @osi_booker_labels = orders_osi_booker.keys.map { |osi| osi.blank? ? 'No Osi Bookers' : osi_bookers[osi] }
    # @osi_booker_values = orders_osi_booker.values.map { |osis| osis.sum(&:nat_amt) }
    current_month = Date.current
    next_two_month = (current_month + 2.months).end_of_month
    pre_two_month = (current_month - 2.months).beginning_of_month
    month_years = OrderInfomation.select("DATE_FORMAT(flt_date, '%m/%Y') AS month_date")
                                 .flt_date_range(pre_two_month, next_two_month)
                                 .where.not(flt_date: nil).distinct
    osi_ca_month = OrderInfomation.select("DATE_FORMAT(issue_date, '%m/%Y') AS month_date")
                                  .issue_date_range(pre_two_month, next_two_month).distinct
    osi_ca_month = osi_ca_month.map {|e| e.month_date.to_date }.sort
    month_years = month_years.map {|e| e.month_date.to_date }.sort
    @osi_ca_month = osi_ca_month.map { |e| e.strftime("%m/%Y") }
    @month_years = month_years.map { |e| e.strftime("%m/%Y") }
    @osi_cas = OsiCa.pluck(:code, :name).to_h
    total_by_osis = OrderInfomation.load_osi_ca_by_issue_date.issue_date_range(pre_two_month, next_two_month)
    data = {}
    total_by_osis.each do |e|
      data[e.osi_ca] = {} if data[e.osi_ca].blank?
      data[e.osi_ca].merge!(e.month_date => e.total_value)
    end
    @total_by_osis = data
    @osi_bookers = OsiBooker.pluck(:code, :name).to_h
    total_by_osis_booker = OrderInfomation.load_value_by_booker.flt_date_range(pre_two_month, next_two_month)
    data_booker = {}
    total_by_osis_booker.each do |e|
      data_booker[e.osi_booker] = {} if data_booker[e.osi_booker].blank?
      data_booker[e.osi_booker].merge!(e.month_date => e.total_value)
    end
    @total_by_osis_booker = data_booker
  end

  def download_osi
    month_years = OrderInfomation.select("DATE_FORMAT(flt_date, '%m/%Y') AS month_date")
                                 .where.not(flt_date: nil).distinct
    month_years = month_years.map {|e| e.month_date.to_date }.sort
    month_years = month_years.map { |e| e.strftime("%m/%Y") }
    total_data = {}
    osi_cas = OsiCa.pluck(:code, :name).to_h
    total_by_osis = OrderInfomation.load_osi_ca_by_issue_date
    data = {}
    total_by_osis.each do |e|
      data[e.osi_ca] = {} if data[e.osi_ca].blank?
      data[e.osi_ca].merge!(e.month_date => e.total_value)
    end

    osi_bookers = OsiBooker.pluck(:code, :name).to_h
    total_by_osis_booker = OrderInfomation.load_value_by_booker
    data_booker = {}
    total_by_osis_booker.each do |e|
      data_booker[e.osi_booker] = {} if data_booker[e.osi_booker].blank?
      data_booker[e.osi_booker].merge!(e.month_date => e.total_value)
    end
    path = "#{Rails.root}/tmp/excel"
    FileUtils.mkdir_p(path) unless File.directory?(path)
    file_path = "#{path}/#{current_user.id}_total_osi.xlsx"
    File.delete(file_path) if File.exists?(file_path)
    object = { file_path: file_path, osi_cas: osi_cas, osi_bookers: osi_bookers, data_cas: data, data_bookers: data_booker,
               month_years: month_years}

    if load_report_osi(object) == :no_error
      filename = "Report_OSI_#{Time.now.strftime("%Y%m%d")}.xlsx"
      send_file(file_path,
                type: "text/xlsx; charset=utf-8; header=present",
                filename: filename)
    else
      redirect_to root_path, danger: "Cannot export Excel"
    end
  rescue StandardError => e
    redirect_to root_path, danger: "Cannot export Excel"
  end

  private

  def load_report_osi(object)

    workbook = FastExcel.open(object[:file_path])
    worksheet = workbook.add_worksheet

    bold = workbook.add_format(bold: true, border: :border_thin)

    worksheet.append_row(['Osi Name', 'Osi Code'] + object[:month_years], bold)
    object[:data_cas].each do |key, value|
      row = [object[:osi_cas][key], key]
      object[:month_years].each do |date|
        row << (value[date].to_i.positive? ? value[date] : 0)
      end
      worksheet.append_row(row)
    end
    object[:data_bookers].each do |key, value|
      row = [object[:osi_bookers][key], key]
      object[:month_years].each do |date|
        row << (value[date].to_i.positive? ? value[date] : 0)
      end
      worksheet.append_row(row)
    end
    workbook.close
  end
end

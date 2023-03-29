class HomesController < ApplicationController
  def dashboard
    orders = OrderInfomation.all
    @total_order = orders.count
    @total = orders.sum(&:nat_amt)
    @total_not_add = orders.where(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_added = orders.where.not(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_by_booker = orders.where.not(osi_booker: [nil, '']).sum(&:nat_amt)
    @month_years = OrderInfomation.select("DATE_FORMAT(issue_date, '%m/%Y') AS month_date")
                                  .distinct.map(&:month_date)
    # orders_osi = orders.group_by(&:osi_ca)
    @osi_cas = OsiCa.pluck(:code, :name).to_h
    total_by_osis = OrderInfomation.load_value_by_osi
    data = {}
    total_by_osis.each do |e|
      data[e.osi_ca] = {} if data[e.osi_ca].blank?
      data[e.osi_ca].merge!(e.month_date => e.total_value)
    end
    @total_by_osis = data
    # @osi_labels = orders_osi.keys.map { |osi| osi.blank? ? 'No Osi' : osi_cas[osi] }
    # @osi_values = orders_osi.values.map { |osis| osis.sum(&:nat_amt) }
    # @data_chart = [@total_added, @total_not_add]

    # orders_osi_booker = orders.group_by(&:osi_booker)
    # osi_bookers = OsiBooker.pluck(:code, :name).to_h
    # @osi_booker_labels = orders_osi_booker.keys.map { |osi| osi.blank? ? 'No Osi Bookers' : osi_bookers[osi] }
    # @osi_booker_values = orders_osi_booker.values.map { |osis| osis.sum(&:nat_amt) }
  end
end

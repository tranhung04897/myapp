class HomesController < ApplicationController
  def dashboard
    orders = OrderInfomation.all
    @total_order = orders.count
    @total = orders.sum(&:nat_amt)
    @total_not_add = orders.where(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_added = orders.where.not(osi_ca: [nil, '']).sum(&:nat_amt)
    @total_by_booker = orders.where.not(osi_booker: [nil, '']).sum(&:nat_amt)
    orders_osi = orders.group_by(&:osi_ca)
    osi_cas = OsiCa.pluck(:code, :name).to_h
    @osi_labels = orders_osi.keys.map { |osi| osi.blank? ? 'No Osi' : osi_cas[osi] }
    @osi_values = orders_osi.values.map { |osis| osis.sum(&:nat_amt) }
    @data_chart = [@total_added, @total_not_add]

    orders_osi_booker = orders.group_by(&:osi_booker)
    osi_bookers = OsiBooker.pluck(:code, :name).to_h
    @osi_booker_labels = orders_osi_booker.keys.map { |osi| osi.blank? ? 'No Osi Bookers' : osi_bookers[osi] }
    @osi_booker_values = orders_osi_booker.values.map { |osis| osis.sum(&:nat_amt) }
  end
end

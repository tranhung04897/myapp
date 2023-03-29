class ChangeNilToSingleQuote < ActiveRecord::Migration[7.0]
  def up
    OrderInfomation.all.each do |order|
      order.osi_ca = '' if order.osi_ca.nil?
      order.osi_booker = '' if order.osi_booker.nil?
      order.save
    end
  end
end

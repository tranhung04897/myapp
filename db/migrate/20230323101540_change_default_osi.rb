class ChangeDefaultOsi < ActiveRecord::Migration[7.0]
  def change
    change_column_default :order_infomations, :osi_ca, ''
    change_column_default :order_infomations, :osi_booker, ''
  end
end

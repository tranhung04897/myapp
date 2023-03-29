class ChangeTypeColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :order_infomations, :flt_date, :date
  end
end

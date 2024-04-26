class AddColumnTotalFullIntoOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :order_infomations, :total_full, :bigint, default: 0
  end
end

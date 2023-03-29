class AddLimitToOsi < ActiveRecord::Migration[7.0]
  def change
    add_column :osi_cas, :limit_value, :bigint, default: 0
    add_column :osi_bookers, :limit_value, :bigint, default: 0
  end
end

class CreateOrderInfomations < ActiveRecord::Migration[7.0]
  def change
    create_table :order_infomations do |t|
      t.date   :issue_date
      t.string :flt_date
      t.string :ticket_number, null: false
      t.string :pax_name
      t.string :route
      t.string :type_ticket
      t.string :pnr
      t.string :coupon_status
      t.string :class_ticket
      t.string :ag
      t.string :osi_ca
      t.string :osi_booker
      t.bigint :fare
      t.bigint :charge
      t.bigint :nat_amt
      t.string :saler

      t.timestamps
    end
    add_index :order_infomations, [:ticket_number, :type_ticket], unique: true
  end
end

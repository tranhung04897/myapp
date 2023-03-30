class CreateTrackingHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_histories do |t|
      t.date :date_tracking
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tracking_histories, [:date_tracking, :user_id], unique: true
  end
end

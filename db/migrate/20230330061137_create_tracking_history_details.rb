class CreateTrackingHistoryDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_history_details do |t|
      t.references :tracking_history, null: false, foreign_key: true
      t.text :action_submit
      t.text :content

      t.timestamps
    end
  end
end

class CreateOsiCas < ActiveRecord::Migration[7.0]
  def change
    create_table :osi_cas do |t|
      t.string :name
      t.string :code
      t.string :syntax_osi

      t.timestamps
    end
  end
end

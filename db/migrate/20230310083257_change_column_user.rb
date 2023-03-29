class ChangeColumnUser < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :string, null: true
    add_column    :users, :username, :string, after: :email, unique: true, null: false, default: "", comment: 'User name'
    add_column    :users, :name, :string, after: :email, default: ''
  end
end

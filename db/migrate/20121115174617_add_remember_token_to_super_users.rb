class AddRememberTokenToSuperUsers < ActiveRecord::Migration
  def change
    add_column :super_users, :remember_token, :string
    add_index :super_users, :remember_token
  end
end

class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :super_users, :password_digest, :string
  end
end

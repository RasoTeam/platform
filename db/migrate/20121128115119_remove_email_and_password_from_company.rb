class RemoveEmailAndPasswordFromCompany < ActiveRecord::Migration
  def up
    remove_column :companies, :email
    remove_column :companies, :password_digest
  end

  def down
    add_column :companies, :password_digest, :string
    add_column :companies, :email, :string
  end
end

class RemoveEmailAndPasswordFromCompany < ActiveRecord::Migration
  def up
    remove_column :companies, :email
    remove_column :companies, :pasword_digest
  end

  def down
    add_column :companies, :pasword_digest, :string
    add_column :companies, :email, :string
  end
end

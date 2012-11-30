class RemoveEmailAndPasswordFromCompany < ActiveRecord::Migration
  def up
    remove_column :companies, :email
  end

  def down
    add_column :companies, :email, :string
  end
end

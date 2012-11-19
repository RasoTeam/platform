class RemovePasswordDigestFromCompanies < ActiveRecord::Migration

  def change
    remove_column :companies, :password_diges
  end
end

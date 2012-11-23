class RemovePasswordDigestFromCompanies < ActiveRecord::Migration

  def change
    remove_column :companies, :password_digest
  end
end

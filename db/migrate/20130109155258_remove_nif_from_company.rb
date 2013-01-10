class RemoveNifFromCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :nif
  end
end

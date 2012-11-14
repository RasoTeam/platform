class AddTagToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :tag, :string
  end
end

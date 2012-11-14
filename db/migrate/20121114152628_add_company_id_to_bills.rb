class AddCompanyIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :company_id, :integer
  end
end

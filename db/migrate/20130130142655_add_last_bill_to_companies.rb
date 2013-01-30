class AddLastBillToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :last_bill, :date
  end
end

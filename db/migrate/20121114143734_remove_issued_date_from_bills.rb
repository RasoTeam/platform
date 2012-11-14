class RemoveIssuedDateFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :issued_date
  end
end

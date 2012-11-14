class AddPaymentDateToBills < ActiveRecord::Migration
  def change
    add_column :bills, :payment_date, :date
  end
end

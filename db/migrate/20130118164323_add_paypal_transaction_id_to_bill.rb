class AddPaypalTransactionIdToBill < ActiveRecord::Migration
  def change
    add_column :bills, :paypal_transaction_id, :string
  end
end

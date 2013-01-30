class AddMonthToBills < ActiveRecord::Migration
  def change
    add_column :bills, :month, :date
  end
end

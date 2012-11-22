class AddTimeOffDaysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_off_days, :integer
  end
end

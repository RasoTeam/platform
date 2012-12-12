class UpdateTimeOffDaysOnUsers < ActiveRecord::Migration
  def up
  	change_table :users do |t|
      t.change :time_off_days, :integer, :default => 0
    end
    User.update_all ["time_off_days = ?", 0]
  end

  def down
  end
end

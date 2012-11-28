class RenameTimeOffsDateColumns < ActiveRecord::Migration
  def up
    rename_column :time_offs, :start_date, :start_at
    rename_column :time_offs, :end_date, :end_at
  end

  def down
    rename_column :time_offs, :start_date, :start_at
    rename_column :time_offs, :end_date, :end_at
  end
end

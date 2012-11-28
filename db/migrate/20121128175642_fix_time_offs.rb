class FixTimeOffs < ActiveRecord::Migration
  def change
    rename_column :time_offs, :start_date, :start_at
    rename_column :time_offs, :end_date, :end_at
    add_column :time_offs, :name, :string
    add_column :time_offs, :color, :string
  end
end

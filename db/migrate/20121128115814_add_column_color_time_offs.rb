class AddColumnColorTimeOffs < ActiveRecord::Migration
  def up
    add_column :time_offs, :color, :string
  end

  def down
    add_column :time_offs, :color, :string
  end
end

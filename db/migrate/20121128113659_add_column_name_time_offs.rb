class AddColumnNameTimeOffs < ActiveRecord::Migration
  def up
    add_column :time_offs, :name, :string
  end

  def down
    add_column :time_offs, :name, :string
  end
end

class RenameColumnTimeoff < ActiveRecord::Migration
  def up
    rename_column :time_offs, :type, :category
  end

  def down
    rename_column :time_offs, :type, :category
  end
end

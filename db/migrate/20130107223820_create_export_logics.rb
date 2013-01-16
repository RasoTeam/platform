class CreateExportLogics < ActiveRecord::Migration
  def change
    create_table :export_logics do |t|

      t.timestamps
    end
  end
end

class CreateImportLogics < ActiveRecord::Migration
  def change
    create_table :import_logics do |t|

      t.timestamps
    end
  end
end

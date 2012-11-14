class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.decimal :value
      t.date :issued_date
      t.integer :state

      t.timestamps
    end
  end
end

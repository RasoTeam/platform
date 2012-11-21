class CreateTimeOffs < ActiveRecord::Migration
  def change
    create_table :time_offs do |t|
      t.integer :user_id
      t.integer :type
      t.integer :state
      t.text :description
      t.integer :days
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end

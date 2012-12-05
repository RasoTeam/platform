class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :training_id
      t.integer :company_id
      t.date :start_at
      t.date :end_at
      t.integer :category
      t.integer :state
      t.string :lecturer

      t.timestamps
    end
  end
end

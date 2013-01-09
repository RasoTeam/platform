class CreateCourseSignups < ActiveRecord::Migration
  def change
    create_table :course_signups do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :status

      t.timestamps
    end
  end
end

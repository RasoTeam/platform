class FixCourse < ActiveRecord::Migration
  def change
    add_column :courses, :name, :string
    add_column :courses, :color, :string
  end
end

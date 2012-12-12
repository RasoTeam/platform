class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string :name
      t.text :desc
      t.integer :company_id

      t.timestamps
    end
  end
end

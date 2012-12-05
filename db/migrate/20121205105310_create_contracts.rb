class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.date :start_date
      t.date :end_date
      t.string :job_title
      t.decimal :value
      t.integer :user_id

      t.timestamps
    end
  end
end

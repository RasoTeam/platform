class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :location
      t.string :nationality
      t.integer :phone
      t.string :email
      t.string :file_path
      t.integer :job_offer_id

      t.timestamps
    end
  end
end

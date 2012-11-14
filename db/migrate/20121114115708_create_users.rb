class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :company_id
      t.string :email
      t.integer :role
      t.string :name
      t.integer :state

      t.timestamps
    end
  end
end

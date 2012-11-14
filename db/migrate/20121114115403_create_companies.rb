class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo_url
      t.string :email
      t.string :address
      t.string :nif
      t.integer :state

      t.timestamps
    end
  end
end

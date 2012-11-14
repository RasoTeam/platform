class CreateSuperUsers < ActiveRecord::Migration
  def change
    create_table :super_users do |t|
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end

class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.string :nome
      t.text :texto
      t.string :tipo
      t.string :url

      t.timestamps
    end
  end
end

class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|

      t.string :description
      t.date :period_begin
      t.date :period_end
      t.string :status
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end

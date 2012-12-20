class CreateEvaluationParameters < ActiveRecord::Migration
  def change
    create_table :evaluation_parameters do |t|
      t.integer :evaluation_id
      t.integer :parameter_id
      t.integer :min_value
      t.integer :max_value

      t.timestamps
    end
  end
end

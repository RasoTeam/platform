class CreateEvaluationUserParameters < ActiveRecord::Migration

  def up
    create_table :evaluation_user_parameters do |t|
          t.integer :evaluation_id
          t.integer :user_id
          t.integer :parameter_id
          t.integer :min_value
          t.integer :max_value
          t.integer :result

          t.timestamps
        end
  end

  def down
    drop_table :evaluation_user_parameters
  end
end

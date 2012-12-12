class CreateEvalUsers < ActiveRecord::Migration
  def change
    create_table :eval_users , :id => false do |t|
      t.integer :evaluation_id
      t.integer :evaluator_id
      t.integer :evaluatee_id

      t.timestamps
    end
  end

end

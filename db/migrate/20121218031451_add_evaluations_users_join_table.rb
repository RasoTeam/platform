class AddEvaluationsUsersJoinTable < ActiveRecord::Migration

  def up
    create_table :evaluations_users , :id => false do |t|
      t.integer :evaluation_id
      t.integer :user_id
    end
  end


  def down
    drop_table :evaluations_users
  end
end

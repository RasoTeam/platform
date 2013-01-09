class AddResultToEvaluationParameters < ActiveRecord::Migration
  def change
    add_column :evaluation_parameters, :result, :integer
  end
end

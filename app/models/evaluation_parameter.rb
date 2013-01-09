class EvaluationParameter < ActiveRecord::Base

  attr_accessible :evaluation_id, :max_value, :min_value, :parameter_id

  belongs_to :evaluation
  belongs_to :parameter
end

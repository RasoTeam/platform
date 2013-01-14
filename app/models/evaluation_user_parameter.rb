class EvaluationUserParameter < ActiveRecord::Base
  attr_accessible :evaluation_id, :max_value, :min_value, :parameter_id, :result, :user_id ,:_destroy
  attr_accessor :_destroy


  belongs_to :evaluation
  belongs_to :parameter
  belongs_to :user

end

# == Eval User Model
class EvalUser < ActiveRecord::Base
  attr_accessible :evaluatee_id, :evaluation_id, :evaluator_id
end

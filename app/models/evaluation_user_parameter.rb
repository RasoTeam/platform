# == Schema Information
#
# Table name: evaluation_user_parameters
#
#  id            :integer          not null, primary key
#  evaluation_id :integer
#  user_id       :integer
#  parameter_id  :integer
#  min_value     :integer
#  max_value     :integer
#  result        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class EvaluationUserParameter < ActiveRecord::Base
  attr_accessible :evaluation_id, :max_value, :min_value, :parameter_id, :result, :user_id ,:_destroy
  attr_accessor :_destroy


  belongs_to :evaluation
  belongs_to :parameter
  belongs_to :user

end

# == Schema Information
#
# Table name: evaluation_parameters
#
#  id            :integer          not null, primary key
#  evaluation_id :integer
#  parameter_id  :integer
#  min_value     :integer
#  max_value     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  result        :integer
#

class EvaluationParameter < ActiveRecord::Base

  attr_accessible :evaluation_id, :max_value, :min_value, :parameter_id

  belongs_to :evaluation
  belongs_to :parameter
end

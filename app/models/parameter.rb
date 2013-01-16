# == Parameter Model
#  Parameter for an evaluation - Component for the evaluation
#
# == Schema Information
#
# Table name: parameters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Parameter < ActiveRecord::Base

  attr_accessible :description, :name

  has_many :evaluations , :through => :evaluation_parameters
  has_many :evaluation_parameters

  has_many :evaluations , :through => :evaluation_user_parameters
  has_many :evaluation_user_parameters
end

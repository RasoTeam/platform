class Parameter < ActiveRecord::Base

  attr_accessible :description, :name

  has_many :evaluations , :through => :evaluation_parameters

  has_many :evaluation_parameters
end

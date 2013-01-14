class Evaluation < ActiveRecord::Base

  attr_accessible :description, :period_begin, :period_end, :status, :user_id

  has_and_belongs_to_many :users

  belongs_to :company

  has_many :parameters , :through => :evaluation_parameters
  has_many :evaluation_parameters

  has_many :parameters , :through => :evaluation_user_parameters
  has_many :evaluation_user_parameters

  has_many :user , :through => :evaluation_user_parameters
  has_many :evaluation_user_parameters

  accepts_nested_attributes_for :evaluation_parameters
  accepts_nested_attributes_for :evaluation_user_parameters ,:allow_destroy => true

end

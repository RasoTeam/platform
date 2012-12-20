class Evaluation < ActiveRecord::Base

  attr_accessible :description, :period_begin, :period_end, :status, :user_id

  has_and_belongs_to_many :users

  belongs_to :company

  has_many :parameters , :through => :evaluation_parameters

end

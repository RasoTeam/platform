# == Evaluation Model
#  Companies can create evaluation plans. Each evaluation has evaluations parameters (components in which an employee is evaluated). 
#  Employees which are going to be evaluated have to be specified as well as their evaluators.
#
# == Schema Information
#
# Table name: evaluations
#
#  id           :integer          not null, primary key
#  description  :string(255)
#  period_begin :date
#  period_end   :date
#  status       :string(255)
#  user_id      :integer
#  company_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Evaluation < ActiveRecord::Base

  attr_accessible :description, :period_begin, :period_end, :status, :user_id

  validates :description, :presence => :true
  validates :period_begin , :presence => :true
  validates :period_end , :presence => :true
  validates_inclusion_of :status , :in => ["Active","Closed"]

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

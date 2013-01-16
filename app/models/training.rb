# == Schema Information
#
# Table name: trainings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Training < ActiveRecord::Base
  attr_accessible :company_id, :desc, :name
  belongs_to :company
  has_many :courses
  
  validates :name, :presence => true
end

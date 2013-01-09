class Training < ActiveRecord::Base
  attr_accessible :company_id, :desc, :name
  belongs_to :company
  has_many :courses
  
  validates :name, :presence => true
end

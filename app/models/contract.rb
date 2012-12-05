class Contract < ActiveRecord::Base
  attr_accessible :end_date, :job_title, :start_date, :user_id, :value
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 

end

# STATE: 
#       0 - INACTIVE 
#       1 - ACTIVE 
#       2 - ONHOLD
# CATEGORY: 
#       1 - PUBLIC
#       2 - PRIVATE
class Course < ActiveRecord::Base
  attr_accessible :category, :company_id, :end_at, :lecturer, :start_at, :state, :training_id, :name
  has_many :course_signups
  has_many :users, :through => :course_signups
  belongs_to :training
  has_and_belongs_to_many :users
  has_event_calendar
  
  validates :name, :presence => true
  validates :lecturer, :presence => true
  
  validates :start_at, :presence => true,
                       :timeliness => { :on_or_after => lambda { Date.current }, 
                                        :on_or_after_message => ':start_at >= today',
                                        :type => :date}
end

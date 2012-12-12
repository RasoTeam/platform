# STATE: 0 - INACTIVE; 1 - ACTIVE; 2 - ONHOLD
# CATEGORY: 1 - PUBLIC; 2 - PRIVATE
class Course < ActiveRecord::Base
  attr_accessible :category, :company_id, :end_at, :lecturer, :start_at, :state, :training_id, :name
  belongs_to :training
  has_and_belongs_to_many :users
  has_event_calendar
  
end

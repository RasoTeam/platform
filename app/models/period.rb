class Period < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :state, :user_id
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :state, presence: true,
  					:numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => -1,
                                       :less_than_or_equal_to => 1 }
end
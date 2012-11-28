# == Schema Information
#
# Table name: time_offs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category    :integer
#  state       :integer
#  description :text
#  days        :integer
#  start_date  :date
#  end_date    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TimeOff < ActiveRecord::Base
  attr_accessor :credits
  attr_accessible :days, :description, :end_at, :start_at, :state, :category, :company_id, :user_id, :credits, :name
  belongs_to :user
  has_event_calendar


  #before_validation :fix_date
  before_validation :set_days

  validates :user_id, :presence => true

  validates :end_at, :presence => true,
                       :timeliness => { :after => lambda { :start_date },
                                        :after_message => ':end_at > :start_at',
                                        :type => :date}

  validates :start_at, :presence => true,
                         :timeliness => { :after => lambda { Date.current }, 
                                          :after_message => ':start_at > today',
                                          :type => :date}

  validates :category, :presence => true, 
                       :numericality => { :only_integer => true,
                                          :greater_than_or_equal_to => 0,
                                          :less_than_or_equal_to => 3 }

  validates :state, :presence => true, 
                    :numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => -1,
                                       :less_than_or_equal_to => 1 }

  validates :days, :presence => true,
                   :numericality => { :onlu_integer => true,
                                      :greater_than_or_equal_to => 0 } 

  validates :credits, :presence => true,
                      :numericality => { :onlu_integer => true,
                                         :greater_than_or_equal_to => :days } 

  def days_diff
    (self.end_at - self.start_at).to_i
  end

  private
    def set_days
      self.days = days_diff
    end
end

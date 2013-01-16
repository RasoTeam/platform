
class TimeOff < ActiveRecord::Base
  attr_accessor :credits
  attr_accessible :days, :description, :end_at, :start_at, :state, :category, :company_id, :user_id, :credits, :name, :total_credits
  belongs_to :user
  has_event_calendar
  
  before_validation :set_days
  
  validates :total_credits, :presence => true,
                            :numericality => { :only_integer => true,
                                               :greater_than_or_equal_to => 1 }

  validates :credits, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => :total_credits },
                      :if => :is_sick?

  validates :start_at, :presence => true,
                       :timeliness => { :on_or_after => lambda { Date.current }, 
                                        :on_or_after_message => ':start_at >= today',
                                        :type => :date}

  #validates :credits, :presence => true,
  #                    :numericality => { :only_integer => true,
  #                                       :greater_than_or_equal_to => :days }

  def is_sick?
    category == 0 
  end

  def days_diff
    if self.end_at.nil? || self.start_at.nil?
      return 0
    end
    n = Integer(self.end_at - self.start_at) + 1
    return n
  end

  private
    def set_days
      self.total_credits = days_diff
    end
end

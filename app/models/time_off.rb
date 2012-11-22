class TimeOff < ActiveRecord::Base
  attr_accessor :credits
  attr_accessible :days, :description, :end_date, :start_date, :state, :category, :user_id, :credits
  belongs_to :user


  before_validation :set_days

  validates :user_id, :presence => true

  validates :end_date, :presence => true,
                       :timeliness => { :after => lambda { :start_date },
                                        :after_message => ':end_date > :start_date',
                                        :type => :date}

  validates :start_date, :presence => true,
                         :timeliness => { :after => lambda { Date.current }, 
                                          :after_message => ':start_date > today',
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
    (self.end_date - self.start_date).to_i
  end

  private
    def set_days
      self.days = days_diff
    end
end

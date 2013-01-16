# == Period Model
#  This Model is used to keep the period when an user is active/inactive. Useful to calculate the monthly price for a company.
#
# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  start_date :date
#  end_date   :date
#  state      :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
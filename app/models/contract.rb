# == Schema Information
#
# Table name: contracts
#
#  id         :integer          not null, primary key
#  start_date :date
#  end_date   :date
#  job_title  :string(255)
#  value      :decimal(, )
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contract < ActiveRecord::Base
  attr_accessible :end_date, :job_title, :start_date, :user_id, :value
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 

end

# == Schema Information
#
# Table name: bills
#
#  id           :integer          not null, primary key
#  value        :decimal(, )
#  issued_date  :date
#  state        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payment_date :date
#

class Bill < ActiveRecord::Base
  attr_accessible :issued_date, :state, :value

  validates :issued_date, presence:true
  validates :state, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 
end

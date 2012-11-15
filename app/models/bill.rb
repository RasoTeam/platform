# == Schema Information
#
# Table name: bills
#
#  id           :integer          not null, primary key
#  value        :decimal(, )
#  state        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payment_date :date
#  company_id   :integer
#

class Bill < ActiveRecord::Base
  attr_accessible :payment_date, :state, :value, :company_id
  belongs_to :companies

  validates :company_id, presence: true
  validates :state, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 
end

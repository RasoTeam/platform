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
  belongs_to :company

  validates :company_id, presence: true
  validates :state, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 

  def self.search(search,order,filt)
    order ||= "DESC"
    filt ||= ">= 0"
    
    if search
      where('state '+filt+ ' AND (id LIKE ? OR company_id IN (SELECT id FROM companies WHERE name LIKE ?))','%'+search+'%','%'+search+'%' ).order("created_at "+order)
    else
      order("created_at "+order)
    end
  end
end
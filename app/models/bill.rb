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

  def self.search(search)
    if search
      where('id LIKE ? OR company_id IN (SELECT id FROM companies WHERE name LIKE ?)','%'+search+'%','%'+search+'%' ).order("created_at Desc")
    else
      order("created_at Desc")
    end
  end
end

#order = params[:order]
#      order ||= "DESC"
#
#     filt = params[:filt]
#      filt ||= ">= 0"
#      
#      @bills = Bill.order("created_at "+order).where("state "+filt).paginate(:page => params[:page], :per_page => 4)
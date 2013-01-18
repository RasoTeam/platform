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

# Company Bill Model
class Bill < ActiveRecord::Base
  attr_accessible :payment_date, :state, :value, :company_id
  belongs_to :company

  validates :company_id, presence: true
  validates :state, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 

def paypal_url(return_url, payment_notification)
  values = {
    :business => 'raso_1358547915_biz@rasohr.com',
    :cmd => '_cart',
    :upload => 1,
    :return => return_url,
    :invoice => id,
    :notify_url => payment_notification
  }
  values.merge!({
    "amount_1" => value,
    "item_name_1" => "Bill " + created_at.to_s
  })
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
end

  # Searches for bills which match certan properties
  #
  # @param [String] search is used to filter bills with id LIKE or bill which belong to a company with an id LIKE
  # @param [String] order is used to order the result as "ASC" or "DESC". default "DESC".
  # @param [String] filt bills by state. 
  #  Examples:
  #  ">= 0"
  #  "< 0"
  #  "==0"
  #  default: ">= 0".
  # @return [Relation] All bills matching the parameters.
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
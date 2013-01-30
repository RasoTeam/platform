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
  attr_accessible :payment_date, :state, :value, :company_id, :month
  belongs_to :company

  validates :company_id, presence: true
  validates :state, presence: true
  validates :value, presence: true, :numericality => {:greater_than => 0} 


# https://cms.paypal.com/cms_content/en_US/files/developer/PP_OrderMgmt_IntegrationGuide.pdf
def paypal_encrypted(return_url, payment_notification)
  values = {
    :business => APP_CONFIG[:paypal_email],
    :cmd => '_cart',
    :upload => 1,
    :return => return_url,
    :invoice => id,
    :currency_code => "EUR",
    :notify_url => payment_notification,
    :cert_id => APP_CONFIG[:paypal_cert_id]
  }
  values.merge!({
    "amount_1" => value,
    "item_name_1" => "Bill from "# + Date::MONTHNAMES[month.month] + " " + month.year.to_s
  })
  encrypt_for_paypal(values)
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

  private
    # Public paypal certificate
    PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
    # Public raso hr certificate
    APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
    # Private raso hr certificate
    APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

    # Encrypt hash for paypal
    def encrypt_for_paypal(values)
      signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
      OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end
end
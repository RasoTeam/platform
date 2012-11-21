# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  logo_url   :string(255)
#  email      :string(255)
#  address    :string(255)
#  nif        :string(255)
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag        :string(255)
#

class Company < ActiveRecord::Base
  attr_accessible :address, :email, :logo_url, :name, :nif, :state, :tag
  has_many :bills
  has_many :users
  has_many :time_outs, :through => :users

  before_save { |company| company.tag = tag.downcase
                          unless company.email.nil? 
                            company.email = email.downcase 
                          end
                        }

  VALID_EMAIL_REGEX = /\A([\w+\-.]+@[a-z\d\-.]+\.[a-z]+)?\z/i
  validates :email, :presence => true,
                    :format => { :with => VALID_EMAIL_REGEX }, 
                    :uniqueness => { :case_sensitive => false }
#                   :if => :has_email?
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :state, :presence => true
  VALID_TAG_REGEX = /\A[a-z\d][a-z\d_-]*\z/i
  validates :tag, :presence => true, 
            :length => { :maximum => 20, :minimum => 3 },
            :format => { :with => VALID_TAG_REGEX }, :uniqueness => { :case_sensitive => false }

  #scope :cenas, lambda { self.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) }

  def self.search(search,order)
    order ||= ""
    if search
      where('name LIKE ? OR tag LIKE ?', '%'+search+'%', '%'+search+'%').order("tag "+order)
    else
      order("tag "+order)
    end
  end

end

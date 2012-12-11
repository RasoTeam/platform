# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  company_id      :integer
#  email           :string(255)
#  role            :integer
#  name            :string(255)
#  state           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  time_off_days   :integer
#

class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :name, :role, :time_off_days, :state, :user_photo, :password, :password_confirmation
  has_secure_password
  belongs_to :company
  has_many :time_offs
  has_many :contracts

  before_create :create_remember_token

  validates :name, :presence => true, :length => { :maximum => 20}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }

  validates :password,  :length => { :minimum => 6 },
                        :if => :verified?
  validates :password_confirmation, :presence => true,
                                    :if => :verified?
  validates :role, :numericality => { :only_integer => true, 
                                      :greater_than_or_equal_to => 0,
                                      :less_than_or_equal_to => 10 }

  validates :state, :numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => -1,
                                       :less_than_or_equal_to => 1 }
  
  def verified?
    self.state != -1
  end

  def self.search(search)
    if search
      where('name LIKE ? OR email LIKE ?', '%'+search+'%', '%'+search+'%').where("role > 0").order("name ")
    else
      where("role > 0").order("name ")
    end
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

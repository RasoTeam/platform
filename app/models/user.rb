# == User Model
#  Main model for the company employees. 
#
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
#  time_off_days   :integer          default(0)
#  user_photo      :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :name, :role, :time_off_days, :state, :user_photo, :password, :password_confirmation, :attach
  has_secure_password
  belongs_to :company
  has_many :time_offs
  has_many :contracts
  has_many :course_signups
  has_many :courses, :through => :course_signups
  has_and_belongs_to_many :courses
  has_many :periods

  has_and_belongs_to_many :evaluations

  has_many :evaluations , :through => :evaluation_user_parameters
  has_many :evaluation_user_parameters

  has_many :parameters , :through => :evaluation_user_parameters
  has_many :evaluation_user_parameters

  has_attached_file :attach, :default_url => "http://placehold.it/200x200"


  before_create :create_remember_token


  #validates_attachment_dimensions :attach, :minimum => 100, :maximum => 800

  validates :name, :presence => true, :length => { :maximum => 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false, :scope => [:company_id] }

  validates :password,  :length => { :minimum => 6 },
                        :if => :verified?, :on => :create, :on => :update_password

  validates :role, :numericality => { :only_integer => true, 
                                      :greater_than_or_equal_to => 0,
                                      :less_than_or_equal_to => 10 }

  validates :state, :numericality => { :only_integer => true,
                                       :greater_than_or_equal_to => -1,
                                       :less_than_or_equal_to => 1 }
  
  # It checks if the user has validated the email address
  def verified?
    self.state != -1
  end

  # @param [String] search Searches for users which has name LIKE or email LIKE
  # @return [Relation] the users matching the property
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

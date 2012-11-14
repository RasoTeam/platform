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
#

class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :name, :role, :state, :password, :password_validation
  has_secure_password
  belongs_to :company

  validates :name, :presence => true, :length => { :maximum => 20}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
	    :format => { :with => VALID_EMAIL_REGEX },
	    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true

  validates :role, :numericality => { :only_integer => true }
end

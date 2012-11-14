# == Schema Information
#
# Table name: super_users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class SuperUser < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  validates :name, :presence => true, :length => { :maximum => 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
	    :format => { :with => VALID_EMAIL_REGEX },
	    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true

end

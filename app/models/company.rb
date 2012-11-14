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
#

class Company < ActiveRecord::Base
  attr_accessible :address, :email, :logo_url, :name, :nif, :state
  has_many :bills

  validates :address, :presence => true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => false }
  validates :name, :presence => true, :length { :maximum => 100 }
  validates :nif, :presence => true
  validates :state, :presence => true
end

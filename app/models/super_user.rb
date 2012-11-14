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
  attr_accessible :email, :name
end

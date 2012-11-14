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
  attr_accessible :company_id, :email, :name, :role, :state
end

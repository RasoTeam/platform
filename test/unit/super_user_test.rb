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

require 'test_helper'

class SuperUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

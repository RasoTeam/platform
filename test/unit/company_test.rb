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

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

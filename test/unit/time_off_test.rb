# == Schema Information
#
# Table name: time_offs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category    :integer
#  state       :integer
#  description :text
#  days        :integer
#  start_at    :date
#  end_at      :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#  color       :string(255)
#  company_id  :integer
#

require 'test_helper'

class TimeOffTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

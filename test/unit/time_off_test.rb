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
#  start_date  :date
#  end_date    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class TimeOffTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

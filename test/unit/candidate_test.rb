# == Schema Information
#
# Table name: candidates
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  location     :string(255)
#  nationality  :string(255)
#  phone        :integer
#  email        :string(255)
#  file_path    :string(255)
#  job_offer_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

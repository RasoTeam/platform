# == Schema Information
#
# Table name: job_offers
#
#  id                 :integer          not null, primary key
#  job_name           :string(255)
#  description        :text
#  required_education :text
#  skills             :text
#  active             :boolean
#  conditions         :text
#  company_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class JobOfferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

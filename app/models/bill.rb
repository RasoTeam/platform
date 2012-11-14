# == Schema Information
#
# Table name: bills
#
#  id          :integer          not null, primary key
#  value       :decimal(, )
#  issued_date :date
#  state       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Bill < ActiveRecord::Base
  attr_accessible :issued_date, :state, :value
end

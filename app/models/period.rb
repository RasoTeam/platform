class Period < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :state, :user_id
end

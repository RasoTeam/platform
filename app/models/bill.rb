class Bill < ActiveRecord::Base
  attr_accessible :issued_date, :state, :value
end

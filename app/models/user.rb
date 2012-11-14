class User < ActiveRecord::Base
  attr_accessible :company_id, :email, :name, :role, :state
end

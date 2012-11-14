class Company < ActiveRecord::Base
  attr_accessible :address, :email, :logo_url, :name, :nif, :state
end

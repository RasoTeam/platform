class SuperUser < ActiveRecord::Base
  attr_accessible :email, :name
end

class Feedback < ActiveRecord::Base
  attr_accessible :email, :nome, :texto, :tipo, :url
  validates_presence_of :email,:texto
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
end
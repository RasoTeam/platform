# == Feedback Model
#  Feedback messages from visitors and employees using the system
#
# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  nome       :string(255)
#  texto      :text
#  tipo       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feedback < ActiveRecord::Base
  attr_accessible :email, :nome, :texto, :tipo, :url
  validates_presence_of :email,:texto
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
end

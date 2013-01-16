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

class Candidate < ActiveRecord::Base
  attr_accessible :email, :file_path, :location, :name, :nationality, :phone

  #pertence a job offer no sentido em que se candidata a um job
  belongs_to :job_offer

  #Validadações para o Candidato
  #validates_format_of :file_path, :with => %r{\.(pdf | xml)$}i
  validates_presence_of :email, :location, :name, :nationality, :phone
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  validates_numericality_of :phone, :only_integer => true

end

class Candidate < ActiveRecord::Base
  attr_accessible :email, :file_path, :location, :name, :nationality, :phone

  #pertence a job offer no sentido em que se candidata a um job
  belongs_to :job_offer

  #Validadações para o Candidato
  validates_presence_of :email, :location, :name, :nationality, :phone
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  validates_numericality_of :phone, :only_integer => true

end

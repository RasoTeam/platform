class Candidate < ActiveRecord::Base
  attr_accessible :email, :file_path, :location, :name, :nationality, :phone

  #pertence a job offer no sentido em que se candidata a um job
  belongs_to :job_offer

  #Validadações para o Candidato
  validates :name , :presence => true

  validates :email , :presence => true

  validates :nationality , :presence => true

  validates :location , :presence => true

end

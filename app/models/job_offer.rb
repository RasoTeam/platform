class JobOffer < ActiveRecord::Base

  #pertence a uma Empresa
  belongs_to :company

  attr_accessible :active, :conditions, :description, :job_name, :required_education, :skills , :created_at

  #VALIDATIONS
  validates :job_name , :presence => true

  validates :description , :presence => true

  validates :skills , :presence => true

  validates :conditions , :presence => true

end

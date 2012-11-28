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
  validates :name , :presence => true

  validates :email , :presence => true

  validates :nationality , :presence => true

  validates :location , :presence => true

end

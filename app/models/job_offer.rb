# == Schema Information
#
# Table name: job_offers
#
#  id                 :integer          not null, primary key
#  job_name           :string(255)
#  description        :text
#  required_education :text
#  skills             :text
#  active             :boolean
#  conditions         :text
#  company_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class JobOffer < ActiveRecord::Base

  #pertence a uma Empresa
  belongs_to :company

  #tem vários candidatos
  has_many :candidates

  attr_accessible :status, :conditions, :description, :job_name, :required_education, :skills , :created_at

  #VALIDATIONS
  validates :job_name , :presence => true

  validates :description , :presence => true

  validates :skills , :presence => true

  validates :conditions , :presence => true

  validates_inclusion_of :status , :in => ["Open","Selection","Closed"]


  ##Utilitário para apresentar ordenadamente uma lista de job_offers - Credits to Tiago
  # search = string usada para pesquisar por nome da job_offer
  # order = de A-Z ou de Z-A, por outras palavras crescente ou decrescente
  def self.search(search,order)
    order ||= ""
    if search #Se foi inserida uma string de pesquisa
      if search == "Open" || search == "Selection" || search == "Closed"
        where('status LIKE ? ', search).order("job_name "+order)
      else
        where('job_name LIKE ? ', '%'+search+'%').order("job_name "+order)
      end
    else #se não apenas foi inserido um parâmetro de ordenação
      order("job_name "+order)
    end
  end

end

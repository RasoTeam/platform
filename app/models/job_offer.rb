# == Job Offer Model
#  Details about a job offer from a company.
# 
# == Schema Information
#
# Table name: job_offers
#
#  id                 :integer          not null, primary key
#  job_name           :string(255)
#  description        :text
#  required_education :text
#  skills             :text
#  status             :string(255)
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
  validates :job_name , :presence => true,  :length => { :maximum => 100 }

  validates :description , :presence => true,  :length => { :maximum => 500 }

  validates :skills , :presence => true ,  :length => { :maximum => 300 }

  validates :conditions , :presence => true,  :length => { :maximum => 200 }

  validates_inclusion_of :status , :in => ["Open","Selection","Closed"]

  # Searches for job offers which match certan properties
  #
  # @param [String] search is used to filter job_offers with name LIKE
  # @param [String] order is used to order the result as "ASC" or "DESC". default "DESC".
  # @return [Relation] All job_offers matching the parameters.
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

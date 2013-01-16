
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

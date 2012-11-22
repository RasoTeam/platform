class Rasocomp::CandidatesController < Rasocomp::ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
    @candidate = Candidate.new
  end

  def apply
    @offer = JobOffer.find(params[:id])
    @candidato = Candidate.new
  end

end

class Rasocomp::CandidatesController < Rasocomp::ApplicationController
  before_filter :manager

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
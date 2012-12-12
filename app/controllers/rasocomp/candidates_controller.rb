class Rasocomp::CandidatesController < Rasocomp::ApplicationController
  before_filter :manager

  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
    @candidate = Candidate.new
  end

  def apply
    @offer = JobOffer.find(params[:id])
    @candidate = Candidate.new
  end

  def show
    @company = Company.find(params[:company_id])
    @offer = JobOffer.find(params[:job_offer_id])
    @candidate = Candidate.find(params[:id])
    @file_text = File.read(@candidate.file_path)
  end

end

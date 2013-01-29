# == Candidates Controller
#  Controller used to manage candidates for a job offer inside a company. Only accessible to managers. 
class Rasocomp::CandidatesController < Rasocomp::ApplicationController
  before_filter :manager

  # Returns all candidates for a job offer.
  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
    @candidate = Candidate.new
  end

  # Apply for a job offer
  def apply
    @offer = JobOffer.find(params[:id])
    @candidate = Candidate.new
  end

  # Show a job offer
  def show
    @company = Company.find(params[:company_id])
    @offer = JobOffer.find(params[:job_offer_id])
    @candidate = Candidate.find(params[:id])
    @file_text = File.read(@candidate.file_path)
  end

  # Show a candidate for a job offer in a company
  def show_candidate
    @company = Company.find(params[:company_id])
    @offer = JobOffer.find(params[:job_offer_id])
    @candidate = Candidate.find(params[:id])
  end

  # Update a candidate in a job offer and company
  def update_status
    @company = Company.find(params[:company_id])
    @offer = JobOffer.find(params[:job_offer_id])
    @candidate = Candidate.find(params[:id])

    @candidate.status = params[:status]

    if @candidate.save
      respond_to do |format|
        format.js {}
      end
    else
      flash[:error] = 'Failure Updating Status'
      redirect_to show_profile_path(@company,@offer,@candidate)

    end

  end

end

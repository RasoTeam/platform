class Public::JobOffersController < Public::ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
  end

  def show
      @offer = JobOffer.find(params[:id])
      @company = @offer.company
  end

  def new
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
    @candidate = Candidate.new
    @candidate.job_offer_id = @offer.id
  end

  def create
    @candidate = Candidate.create(params[:candidate])
    @candidate.job_offer_id = params[:id]

    if @candidate.save
      flash[:success] = "You applied successfully for the job."
      redirect_to public_company_job_offers_path(params[:company_id])
    else
      flash[:alert] = "Something went wrong, try again."
      redirect_to new_apply_path(params[:company_id])
    end
  end

end

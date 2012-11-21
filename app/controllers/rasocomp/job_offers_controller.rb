class Rasocomp::JobOffersController < Rasocomp::ApplicationController

  def index
    @offers = JobOffer.all
    @company = Company.find(params[:company_id])

  end

  def new
    @company = Company.find(params[:company_id])
    @offer = JobOffer.new
  end

  def create
    @company = Company.find(params[:company_id])

    @offer =@company.job_offers.build(params[:job_offer])
    @offer.active = true

    if @offer.save
      redirect_to company_job_offer_path(@company,@offer)
    else
      flash[:error] = 'Could not save'
      render new_company_job_offer_path(@company)
    end
  end

  def show
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
  end

  def edit
    @offer = JobOffer.find(params[:id])
  end

  def update

  end

  def destroy
  end

end

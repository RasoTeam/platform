# == Job Offers Controller
#  Controller to manage job offers
class Rasocomp::JobOffersController < Rasocomp::ApplicationController
  before_filter :manager

  # List all job offers in a company
  def index
    @company = Company.find(params[:company_id])
    #Usa a função search por causa da pesquisa por palavras chave e ordenação -> ver Modelo JobOffer
    @offers = @company.job_offers.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 15)
  end

  # New job offer in a company
  def new
    @company = Company.find(params[:company_id])
    @offer = JobOffer.new
  end

  # Creates a new job offer in a company
  def create
    @company = Company.find(params[:company_id])

    @offer =@company.job_offers.build(params[:job_offer])
    @offer.status = "Open"

    if @offer.save
      flash[:success] = 'New Job Offer Created'
      redirect_to company_job_offers_path
    else
      flash[:error] = 'Could not save!'
      redirect_to new_company_job_offer_path(@company)
    end
  end

  # Shows a job offer in a company
  def show
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
    @candidates = @offer.candidates
  end

  # Edit a job offer in a company
  def edit
    @offer = JobOffer.find(params[:id])
    @company = Company.find(@offer.company)
  end

  # Update a job offer in a company
  def update
    @company = Company.find(params[:company_id])
    @offer = @company.job_offers.find(params[:id])

    if @offer.update_attributes( params[:job_offer])
      redirect_to company_job_offer_path(@company , @offer)
    else
      flash[:error] = 'Failed updating'
      render company_job_offers_path(@company)
    end

  end

  #Updates the status of the job offer
  def update_status
    @company = Company.find(params[:company_id])
    @offer = @company.job_offers.find(params[:job_offer_id])

    #vai buscar o status enviado pelo link
    @offer.status = params[:status]

    if @offer.save
      flash[:success] = "Status updated - " + params[:status]
      redirect_to company_job_offer_path(@company , @offer)
    else
      flash[:error] = 'Failed updating.'
      render company_job_offers_path(@company)
    end

  end

  # Destroy a job offer in a company
  def destroy
    @company = Company.find(params[:company_id])
    @offer = @company.job_offers.find(params[:id])

    if JobOffer.find(params[:id]).destroy
      flash[:success] = 'Job Offer Deleted'
      redirect_to company_job_offers_path(@company)
    else
      flash[:error] = "Problem Deleting"
      redirect_to company_job_offer_path(@company , @offer)
    end
  end

end

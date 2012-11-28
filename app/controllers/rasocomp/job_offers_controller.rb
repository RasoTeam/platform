class Rasocomp::JobOffersController < Rasocomp::ApplicationController
  before_filter :manager

  #Listar todas as ofertas de trabalho de uma empresa
  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
  end

  #Preparar para criar uma nova oferta de trabalho
  def new
    @company = Company.find(params[:company_id])
    @offer = JobOffer.new
  end

  #Criar uma nova oferta de trabalho
  def create
    @company = Company.find(params[:company_id])

    @offer =@company.job_offers.build(params[:job_offer])
    @offer.active = true

    if @offer.save
      flash[:success] = 'New Job Offer Created'
      redirect_to company_job_offers_path
    else
      flash[:error] = 'Could not save!'
      render new_company_job_offer_path(@company)
    end
  end

  #Mostrar uma oferta de trabalho
  def show
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
    @candidates = @offer.candidates
  end

  #Editar uma oferta de trabalho
  def edit
    @offer = JobOffer.find(params[:id])
    @company = Company.find(@offer.company)
  end

  #Actualizar atributos de uma oferta de trabalho
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

  def destroy
    JobOffer.find(params[:id]).destroy
    flash[:success] = 'Job Offer Deleted'

    redirect_to company_job_offers_path
  end

end

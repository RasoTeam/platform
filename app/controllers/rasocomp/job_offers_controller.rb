class Rasocomp::JobOffersController < Rasocomp::ApplicationController

  def appliances
    @offers = JobOffer.all
    @company = Company.find(params[:company_id])
  end

  def showapply
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
  end

  def formapply
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
    @candidate = Candidate.new
    @candidate.job_offer_id = @offer.id
  end

  def createapply
    @candidate = Candidate.create(params[:candidate])
    @candidate.job_offer_id = params[:id]

    if @candidate.save
      flash[:succes] = "You applied successfully for the job."
      redirect_to apply_index_path(params[:company_id])
    else
      flash[:error] = "Something went wrong, try again."
      redirect_to apply_index_path(params[:company_id])
    end
  end

  #Listar todas as ofertas de trabalho de uma empresa
  def index
    @offers = JobOffer.all
    @company = Company.find(params[:company_id])#bug de mostrar todas
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
      redirect_to company_job_offer_path(@company,@offer)
    else
      flash[:error] = 'Could not save!'
      render new_company_job_offer_path(@company)
    end
  end

  #Mostrar uma oferta de trabalho
  def show
    @offer = JobOffer.find(params[:id])
    @company = @offer.company
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
      render company_job_offers_path #bug de mudar de company
    end

  end

  def destroy

  end

  def manage_offer
    @offer = JobOffer.find(params[:id])

  end

end

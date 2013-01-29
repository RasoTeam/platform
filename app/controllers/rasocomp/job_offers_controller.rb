# == Job Offers Controller
#  Controller to manage job offers
class Rasocomp::JobOffersController < Rasocomp::ApplicationController
  before_filter :manager

  @@order = "ASC"
  @@status = "ALL"
  @@search = ""

  # List all job offers in a company
  def index
    @company = Company.find(params[:company_id])
    @offers = job_offers_search(@company, params[:status], params[:order],params[:search]).paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.js {@company
                  @offers}

      format.html {}
    end
    #Usa a função search por causa da pesquisa por palavras chave e ordenação -> ver Modelo JobOffer
    #@offers = @company.job_offers.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 15)
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

  ######################################################################################################################
  #############          METHODS
  ######################################################################################################################

  #Loads the evaluations of the HR Manager
  def job_offers_search(company,status,order,search_string)

    if search_string != nil
      @@search = search_string
    end
    if status != nil
      @@status = status
    end
    if order != nil
      @@order = order
    end

    puts "Params: " + @@search + " " + @@status + " " + @@order

    #Aqui é feita a escolha da query a usar dependendo dos parametros passados
    if @@status != "ALL" #Se não for TUDO, há que respeitar o Status
      if @@search != ""
        evaluations = company.job_offers.where("status = ?" , @@status).where("job_name LIKE '%" + @@search + "%'").order("job_name " + @@order )
        puts "PASSEI 1"
      else
        evaluations = company.job_offers.where("status = ?" , @@status).order("job_name " + @@order )
        puts "PASSEI 2"
      end
    else                 #Se for TUDO, vem tudo, sem respeito por status
      if @@search != ""
        evaluations = company.job_offers.where("job_name LIKE '%" + @@search + "%'").order("job_name " + @@order )
        puts "PASSEI 3"
      else
        evaluations = company.job_offers.order("job_name " +  @@order )
        puts "PASSEI 4"
      end
    end

    return evaluations

  end

end

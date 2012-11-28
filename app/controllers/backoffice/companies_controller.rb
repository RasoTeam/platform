class Backoffice::CompaniesController < Backoffice::ApplicationController
	def index
    @companies = Company.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @companies = Company.search(nil, params[:order]).paginate(:page => params[:page], :per_page => 10)
    @company = Company.find(params[:id])
    @bills = @company.bills
  end

  def edit
    @company = Company.find( params[:id])
  end

  def update

    @company = Company.find( params[:id])
    if @company.update_attributes(params[ :company])
      flash[:success]= t(:successful_update)
      redirect_to backoffice_company_path @company.id
    else
      render 'edit'
    end
  end

  def block
    #state 0-> Active 1->Block 2->Deleted
    @company = Company.find( params[:id])
    @company.state=1
    if @company.update
      flash[:success]= t(:blocked_successful)
    else
      flash[:alert]= t(:error)
    end
    redirect_to backoffice_companies_path

  end


  def destroy
    #state 0-> Active 1->Block 2->Deleted
    @company = Company.find( params[:id])
    @company.state=2
    if @company.update
      flash[:success]= t(:deleted_successful)
    else
      flash[:alert]= t(:error)
    end
    redirect_to backoffice_companies_path

  end




end

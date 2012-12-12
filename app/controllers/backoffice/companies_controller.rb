class Backoffice::CompaniesController < Backoffice::ApplicationController
	def index
    @companies = Company.search(params[:search], params[:order], params[:state]).paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @companies = Company.search(params[:search], params[:order], params[:state]).paginate(:page => params[:page], :per_page => 15)
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
    @company = Company.find( params[:id])
    @company.state=COMPANY_STATE[:blocked]
    if @company.save
      flash[:success]= t(:blocked_successful)
    else
      flash[:alert]= t(:error)
    end
    redirect_to backoffice_companies_path

  end


  def activate
    @company = Company.find( params[:id])
    @company.state=COMPANY_STATE[:active]
    if @company.save
      flash[:success]= t(:activated_successfully)
    else
      flash[:alert]= t(:error)
    end
    redirect_to backoffice_companies_path

  end




end

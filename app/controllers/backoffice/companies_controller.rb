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
end

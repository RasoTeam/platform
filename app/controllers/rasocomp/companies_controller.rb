class Rasocomp::CompaniesController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:edit, :update]

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
      redirect_to company_path @company.id
    else
      render 'edit'
    end
  end

  private
    def manager_or_root
      comp = Company.find(params[:id])
      unless manager_signed_in?(comp.tag) || root_signed_in?(comp.tag)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end
end

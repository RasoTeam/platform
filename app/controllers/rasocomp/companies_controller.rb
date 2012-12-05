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

    new_attributes = Company.new(params[:company])
    if new_attributes.valid? && new_attributes.slug != @company.slug
      user = current_user @company.slug
      user_sign_out @company.slug
      sign_in_user user, new_attributes.slug
    end

    if @company.update_attributes(params[ :company])      
      flash[:success]= t(:successful_update)
      redirect_to company_path @company.id
    else
      render 'edit'
    end
  end
end

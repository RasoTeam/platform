class Rasocomp::CompaniesController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:edit, :update]

  def show
    @companies = Company.search(nil, params[:order]).paginate(:page => params[:page], :per_page => 15)
    @company = Company.find(params[:id])
    @bills = @company.bills
  end

  def edit
    @company = Company.find( params[:id])
  end

  def update
    @company = Company.find( params[:id])

    old = @company.slug
    new_slug = params[:company][:name].parameterize

    if @company.update_attributes(params[:company].merge({slug: new_slug})) 

      if @company.slug != old
        user = current_user old
        user_sign_out old
        sign_in_user user, @company.slug
      end

      flash[:success]= t(:successful_update)
      redirect_to company_path @company
    else
      render 'edit'
    end
  end
end

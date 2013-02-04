# == Company Controller
#  Controller to manage the company.
class Rasocomp::CompaniesController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:edit, :update]
  before_filter :set_user_local if :locale_in_params

  # Shows companies details. Accessible to all users logged in a company.
  def show
    @companies = Company.search(nil, params[:order]).paginate(:page => params[:page], :per_page => 15)
    @company = Company.find(params[:id])
    @bills = @company.bills.paginate(:page => params[:page], :per_page => 5)
    @user = @company.users.build
  end

  # Edit a company. Only accessible to managers and roots
  def edit
    @company = Company.find( params[:id])
  end

  # Update a company. Only accessible to managers and roots.
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

  private
    # If locale is not specified in the parameters and an user is logged in, the user language will be used
    def set_user_local
      company = Company.find( params[:id])
      if user_signed_in?(company.slug)
        I18n.locale = current_user(company.slug).locale || I18n.default_locale
      end
    end

    # Returns whether an params[:locale] is nil or not 
    def locale_in_params
      params[:locale].nil?
    end
end

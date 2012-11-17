class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:user_session][:email].downcase)
    #use some base64 for company ?
    company = Company.find( params[:company_id])
    if user && user.authenticate(params[:user_session][:password])
      sign_in_user(user, company.tag)
      redirect_to company_root_path(params[:company_id])
    else
      flash.now[:error] = t(:invalid_login)
      render 'new'
    end
  end

  def destroy
    company = Company.find( params[:company_id])
    user_sign_out company.tag
    redirect_to company_root_path(params[:company_id])
  end


end

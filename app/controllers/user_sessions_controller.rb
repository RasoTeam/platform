class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:user_session][:email].downcase)
    if user && user.authenticate(params[:user_session][:password])
      sign_in_user user
      redirect_to company_root_path(params[:company_id])
    else
      flash.now[:error] = t(:invalid_login)
      render 'new'
    end
  end

  def destroy
    user_sign_out
    redirect_to company_root_path(params[:company_id])
  end


end

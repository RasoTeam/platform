class Backoffice::SuperUserSessionsController < ApplicationController
  def new
  end

  def create
    super_user = SuperUser.find_by_email(params[:super_user_session][:email])
    if super_user && super_user.authenticate(params[:super_user_session][:password])
      sign_in_super_user super_user
      redirect_to companies_path
    else
      flash.now[:error] = t(:invalid_login)
      render 'new'
    end
  end

  def destroy
    super_user_sign_out
    redirect_to root_path
  end
end

class Public::UserSessionsController < Public::ApplicationController
  layout "nolayout"
  def new
    company = Company.find(params[:company_id])
    if user_signed_in?(company.tag)
      redirect_to user_dashboard_path(company,current_user(company.tag))
    end
  end

  def create
    company = Company.find(params[:company_id])
    user = company.users.find_by_email(params[:user_session][:email].downcase)
    #use some base64 for company ?
    if user && user.state != -1 && user.authenticate(params[:user_session][:password])
      sign_in_user(user, company.tag)
      redirect_to user_dashboard_path company, user
    else
      flash.now[:error] = t(:invalid_login)
      render 'new'
    end
  end

  def destroy
    company = Company.find(params[:company_id])
    user_sign_out company.tag
    redirect_to root_path
  end


end

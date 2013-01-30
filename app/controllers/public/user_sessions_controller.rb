# == User Sessions Controller
class Public::UserSessionsController < Public::ApplicationController
  before_filter :company_active, :only => [:new, :create]

  layout "nolayout"
  # New user session
  def new
    @company = Company.find(params[:company_id])
    if user_signed_in?(@company.slug)
      redirect_to user_dashboard_path(@company,current_user(@company.slug))
    end
  end

  # Creates a new user session
  def create
    @company = Company.find(params[:company_id])
    @user = @company.users.find_by_email(params[:user_session][:email].downcase)
    #use some base64 for company ?
    if @user && @user.state != STATE[:unchecked] && @user.authenticate(params[:user_session][:password])
      if @user.state == STATE[:inactive]
        redirect_to user_blocked_path @user.company
      else
        sign_in_user(@user, @company.slug)
        I18n.locale = @user.locale
        if @user.role == ROOT
          redirect_to company_path @company
        else
          redirect_to user_dashboard_path @company, @user
        end
      end
    else
      flash.now[:alert] = t(:invalid_login)
      render 'new'
    end
  end

  # Destroys a user session
  def destroy
    company = Company.find(params[:company_id])
    user_sign_out company.slug
    redirect_to company_signin_path company
  end


end

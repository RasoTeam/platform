# == Super User Session Controller
class Public::SuperUserSessionsController < Public::ApplicationController
  layout "nolayout"
  
  # New session
  def new
    if super_user_signed_in?
      redirect_to backoffice_super_user_path(current_super_user)
    end
  end

  # Creates a new session
  def create
    super_user = SuperUser.find_by_email(params[:super_user_session][:email])
    if super_user && super_user.authenticate(params[:super_user_session][:password])
      sign_in_super_user super_user
      redirect_to backoffice_stats_path
    else
      flash.now[:alert] = t(:invalid_login)
      render 'new'
    end
  end

  # Destroys the current session
  def destroy
    super_user_sign_out
    redirect_to super_user_signin_path
  end
end

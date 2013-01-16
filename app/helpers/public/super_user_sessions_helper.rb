# Helper to keep super users sessions
module Public::SuperUserSessionsHelper
  
  # Creates a session when a super user logs in
  def sign_in_super_user(superuser)
    cookies.permanent[:remember_super_user_token] = superuser.remember_token
    self.current_super_user = superuser
  end

  # Attribute a super user to the instance variable current_super_user
  def current_super_user=(superuser)
    @current_super_user = superuser
  end

  # Return the super user logged in the system.
  def current_super_user
    @current_super_user ||= SuperUser.find_by_remember_token(cookies[:remember_super_user_token])
  end

  # Return wether a super is user logged in
  def super_user_signed_in?
    !current_super_user.nil?
  end

  # Logs out the current super user
  def super_user_sign_out
    self.current_super_user = nil
    cookies.delete(:remember_super_user_token)
  end
end
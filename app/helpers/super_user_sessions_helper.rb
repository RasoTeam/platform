module SuperUserSessionsHelper
  
  def sign_in_super_user(superuser)
    cookies.permanent[:remember_super_user_token] = superuser.remember_token
    self.current_super_user = superuser
  end

  def current_super_user=(superuser)
    @current_super_user = superuser
  end

  def current_super_user
    @current_super_user ||= SuperUser.find_by_remember_token(cookies[:remember_super_user_token])
  end

  def super_user_signed_in?
    !current_super_user.nil?
  end

  def super_user_sign_out
    self.current_super_user = nil
    cookies.delete(:remember_super_user_token)
  end
end

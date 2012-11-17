module UserSessionsHelper

  def sign_in_user(user)
    cookies.permanent[:remember_user_token] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_user_token])
  end

  def user_signed_in?
    !current_user.nil?
  end

  def user_sign_out
    self.current_user = nil
    cookies.delete(:remember_user_token)
  end

end

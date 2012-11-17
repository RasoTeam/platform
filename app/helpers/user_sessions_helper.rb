module UserSessionsHelper

  def make_cookie(val, tag)
    cookies.permanent[ tag] = val
  end

  def read_cookie( tag)
    return cookies[ tag]
  end

  def sign_in_user(user, tag)
    cookies.permanent[ tag] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user(tag)
    @current_user ||= User.find_by_remember_token(cookies[ tag])
  end

  def user_signed_in?(tag)
    !current_user(tag).nil?
  end

  def user_sign_out(tag)
    self.current_user = nil
    cookies.delete( tag)
  end

end

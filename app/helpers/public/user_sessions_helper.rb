module Public::UserSessionsHelper
  @@x = "fdlsakb123kfjdaFSADyshfdyKJDHAkuyre"

  def make_cookie(val, slug)
    cookies.permanent[ @@x+slug] = val
  end

  def read_cookie( slug)
    return cookies[ @@x+slug]
  end

  def sign_in_user(user, slug)
    cookies.permanent[ @@x+slug] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user(slug)
    @current_user = User.find_by_remember_token(cookies[@@x+slug])
  end

  def user_signed_in?(slug)
    !current_user(slug).nil?
  end

  def user_sign_out(slug)
    self.current_user = nil
    cookies.delete(@@x+slug)
  end

  def manager_signed_in?(slug)
    user_signed_in?(slug) && current_user(slug).role == ROLE[:manager]
  end

  def root_signed_in?(slug)
    user_signed_in?(slug) && current_user(slug).role == ROOT
  end

end

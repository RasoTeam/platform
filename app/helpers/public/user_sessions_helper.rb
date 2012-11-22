module UserSessionsHelper
  @@x = "fdlsakb123kfjdaFSADyshfdyKJDHAkuyre"

  def make_cookie(val, tag)
    cookies.permanent[ @@x+tag] = val
  end

  def read_cookie( tag)
    return cookies[ @@x+tag]
  end

  def sign_in_user(user, tag)
    cookies.permanent[ @@x+tag] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user(tag)
    @current_user = User.find_by_remember_token(cookies[@@x+tag])
  end

  def user_signed_in?(tag)
    !current_user(tag).nil?
  end

  def user_sign_out(tag)
    self.current_user = nil
    cookies.delete(@@x+tag)
  end

  def manager_signed_in?(tag)
    user_signed_in?(tag) && current_user(tag).role == ROLE[:manager]
  end

  def root_signed_in?(tag)
    user_signed_in?(tag) && current_user(tag).role == ROOT
  end

end

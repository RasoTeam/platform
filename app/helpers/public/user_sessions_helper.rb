# Helper to keep super users sessions
module Public::UserSessionsHelper
  @@x = "fdlsakb123kfjdaFSADyshfdyKJDHAkuyre"

  def make_cookie(val, slug)
    cookies.permanent[ @@x+slug] = val
  end

  def read_cookie( slug)
    return cookies[ @@x+slug]
  end

  # Creates a session when a user logs in a company
  def sign_in_user(user, slug)
    cookies.permanent[ @@x+slug] = user.remember_token
    self.current_user = user
  end

  # Attribute a user to the instance variable current_super_user
  def current_user=(user)
    @current_user = user
  end

  # Returns the current user logged in a company with the slug given as parameter
  def current_user(slug)
    @current_user = User.find_by_remember_token(cookies[@@x+slug])
  end

  # Returns wether there is a user logged in a company
  def user_signed_in?(slug)
    !current_user(slug).nil?
  end

  # Logs out from a company with the slug given as parameter
  def user_sign_out(slug)
    self.current_user = nil
    cookies.delete(@@x+slug)
  end

  # Return whether a user is logged in and its role is maneger
  def manager_signed_in?(slug)
    user_signed_in?(slug) && current_user(slug).role == ROLE[:manager]
  end

  # Returns wether a user is logged in and its role is root
  def root_signed_in?(slug)
    user_signed_in?(slug) && current_user(slug).role == ROOT
  end
end

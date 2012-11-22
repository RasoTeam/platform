class ApplicationController < ActionController::Base
  protect_from_forgery
  include Public::SuperUserSessionsHelper
  include Public::UserSessionsHelper
end

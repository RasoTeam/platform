class ApplicationController < ActionController::Base
  protect_from_forgery
  include SuperUserSessionsHelper
  include UserSessionsHelper
end

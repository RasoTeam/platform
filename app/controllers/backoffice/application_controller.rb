# == BackOffice Controller
#  All other backoffice controllers extends from this controller. This section is just for super users.
class Backoffice::ApplicationController < ApplicationController
  before_filter :super_user_authentication
  layout "backoffice"

  private
  # checks if there is a super user logged in
	def super_user_authentication
		unless super_user_signed_in?
			flash[:alert] = t(:no_permission_to_access) 
			redirect_to super_user_signin_path
		end
	end
end
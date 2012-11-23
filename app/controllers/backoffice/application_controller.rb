class Backoffice::ApplicationController < ApplicationController
  before_filter :super_user_authentication
  layout "backoffice"

  private
	def super_user_authentication
		redirect_to super_user_signin_path, notice: t(:no_permission_to_access) unless super_user_signed_in?
	end
end
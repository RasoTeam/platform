class Backoffice::ApplicationController < ApplicationController
  before_filter :super_user_authentication
  layout "backoffice"

	before_filter :createfeedback

	def createfeedback
	    if @feedback.nil?
	    	@feedback = Feedback.new
	    	@feedback.url = params[:url]
	    end
	end

  private
	def super_user_authentication
		unless super_user_signed_in?
			flash[:alert] = t(:no_permission_to_access) 
			redirect_to super_user_signin_path
		end
	end
end
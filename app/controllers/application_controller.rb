class ApplicationController < ActionController::Base
	protect_from_forgery
	include Public::SuperUserSessionsHelper
	include Public::UserSessionsHelper

	before_filter :createfeedback

	def createfeedback
	    if @feedback.nil?
	    	@feedback = Feedback.new
	    	@feedback.url = params[:url]
	    end
	end

end

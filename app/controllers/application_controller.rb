class ApplicationController < ActionController::Base
	protect_from_forgery
	include Public::SuperUserSessionsHelper
	include Public::UserSessionsHelper

	before_filter :createfeedback

	def createfeedback
	    @feedback = Feedback.new
	    @feedback.url = request.fullpath
	end

end

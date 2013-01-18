# == Base Application Controller
#  Controller exteded by all other controllers
class ApplicationController < ActionController::Base
	protect_from_forgery
	include Public::SuperUserSessionsHelper
	include Public::UserSessionsHelper

	before_filter :createfeedback

  # Used to show the feedback button in the left side of the application
	def createfeedback
	    @feedback = Feedback.new
	    @feedback.url = request.fullpath
	end

end

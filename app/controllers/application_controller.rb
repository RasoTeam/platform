# == Base Application Controller
#  Controller exteded by all other controllers
class ApplicationController < ActionController::Base
	protect_from_forgery
	include Public::SuperUserSessionsHelper
	include Public::UserSessionsHelper

	before_filter :createfeedback
  before_filter :set_locale
 
  # Get locale from parameters and set language
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Used to show the feedback button in the left side of the application
	def createfeedback
	    @feedback = Feedback.new
	    @feedback.url = request.fullpath
	end

  # Option to set local parameter in all URL's
  # http://guides.rubyonrails.org/i18n.html
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

end

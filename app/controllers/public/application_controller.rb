class Public::ApplicationController < ApplicationController
	layout "application"

	before_filter :createfeedback

	def createfeedback
	    if @feedback.nil?
	    	@feedback = Feedback.new
	    	@feedback.url = params[:url]
	    end
	end

	private
		def company_active
	      id = params[:company_id]
	      id ||= params[:id]
	      comp = Company.find(id)
	      unless comp.state <= COMPANY_STATE[:active]
	        redirect_to company_blocked_path comp
	      end
	    end
	    
end

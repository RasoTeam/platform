# == Public Controller
#  All other public controllers extends from this controller. This section is available for all visitors unless the company is inavtivate.
class Public::ApplicationController < ApplicationController
	layout "application"

	private
		# Verifies if the company is active
		def company_active
	      id = params[:company_id]
	      id ||= params[:id]
	      comp = Company.find(id)
	      unless comp.state <= COMPANY_STATE[:active]
	        redirect_to company_blocked_path comp
	      end
	    end
	    
end

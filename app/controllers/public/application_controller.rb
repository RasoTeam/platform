class Public::ApplicationController < ApplicationController
	layout "application"

	private
		def company_active
	      id = params[:company_id]
	      id ||= params[:id]
	      comp = Company.find(id)
	      unless comp.state == COMPANY_STATE[:active]
	        redirect_to company_blocked_path comp
	      end
	    end
	    
end

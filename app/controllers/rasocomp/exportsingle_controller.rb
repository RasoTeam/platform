class Rasocomp::ExportsingleController < Rasocomp::ApplicationController

	#The model to be imported
	def choose_users_step
		@company = Company.find(params[:company_id])
		session[:companyid]=@company.id
		session[:companyname]=@company.name
    	@users = @company.users.search(params[:search])

		render :_choose_users_step
	end

	#Exporting the selected users
	def export_users_step

		users_emails_array = params[:users_emails]

		if users_emails_array.nil? == false && users_emails_array.length>0

			@export_logic = ExportLogic.new
   			result = @export_logic.export_users_from_company(session[:companyid], session[:companyname], users_emails_array)

	   		#Make the file available for download
	   		send_file result, :type => "application/vnd.ms-excel", :x_sendfile=>true
			#File.delete(result)

		else
			redirect_to "/companies/" + session[:companyname].downcase + "/users"
		end
	end

end

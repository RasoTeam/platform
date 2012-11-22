class Frontoffice::FrontofficeController < Frontoffice::ApplicationController

	def new
		@company = Company.new
	end

	def create
	    @company = Company.new( params[:company])
	    @company.state = 0;
	    if @company.save
	      user = @company.users.build
	      user.name = 'root'
	      user.email = @company.email
	      user.state = -1
	      user.role = 0
	      user.password_digest = 0
	      user.save
	      UserMailer.verification_email(user).deliver
	      redirect_to company_path @company.id
	    else
	      render 'new'
	    end
  	end
end

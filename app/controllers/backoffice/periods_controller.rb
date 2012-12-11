class Backoffice::PeriodsController < Backoffice::ApplicationController

	def index
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@periods = @user.periods
	end
end

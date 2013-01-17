# Periods controller for the backoffice
class Backoffice::PeriodsController < Backoffice::ApplicationController

  # List all periods from a company
	def index
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@periods = @user.periods
	end
end

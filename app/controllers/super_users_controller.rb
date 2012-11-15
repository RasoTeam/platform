class SuperUsersController < ApplicationController
	def index
		@companies = Company.all
		@bills = Bill.all
	end

	def show
		@company = Company.find(params[:id])
	end
	
	def edit
		@company = Company.find(params[:id])
	end

	def update
		@company = Company.find(params[:id])
		@company.update_attributes(params[:id])

		redirect_to company_path(@company)
	end

	def destroy
		@company = Company.find(params[:id])
		@company.destroy

		redirect_to companies_path
	end
end

class SuperUsersController < ApplicationController
	def index
		@companies = Company.all
	end

	def show
		@companie = Company.find(params[:id])
	end
	
	def edit
		@companie = Company.find(params[:id])
	end
	
	def destroy
	end
end

class Rasocomp::ContractController < ApplicationController
	def show
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.find(params[:id])
	end

	def index
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contracts = @user.contracts
	end

	def edit
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.find(params[:id])
	end

	def update
	    @company = Company.find(params[:company_id])
	    @user = @company.users.find(params[:user_id])
	    @contract = @user.contracts.find(params[:id])
	    
	    if @contract.update_attributes(params[:contract])
	    	redirect_to company_user_contract_path @company.id, @user, @contract
	    else
	    	render 'edit'
	    end
  	end

  	def new
  	end

  	def create
  	end

end

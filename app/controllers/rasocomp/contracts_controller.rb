# == Contracts Controller
#  Controller to manage contracts inside a company.
class Rasocomp::ContractsController < Rasocomp::ApplicationController
	before_filter :manager_or_user_self, :only => [:show]
	before_filter :manager, :only => [:edit, :update, :new, :create, :index]
	
	# Shows a contract. Only accessible to managers and to the own user.
	def show
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.find(params[:id])
	end

	# Lists all contracts in a company for one employee. Only accessible to 
	def index
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contracts = @user.contracts
	end

	# Edit a contract from an employee. Only accessible to managers.
	def edit
		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.find(params[:id])
	end

	# Update a contract from an employee. Only accessible to managers.
	def update
	    @company = Company.find(params[:company_id])
	    @user = @company.users.find(params[:user_id])
	    @contract = @user.contracts.find(params[:id])
	    
	    if @contract.update_attributes(params[:contract])
	    	redirect_to company_user_path @company.id, @user
	    else
	    	render 'edit'
	    end
  	end

  	# New contract for employee. Only accessible to managers.
  	def new
  		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.build
  	end

  	# Creates a new contract for employee. Only accessible to managers.
  	def create
	    @company = Company.find(params[:company_id])
	    @user = @company.users.find(params[:user_id])
	    @contract = @user.contracts.build(params[:contract])
	    if @contract.save
	      redirect_to company_user_path @company.id, @user
	    else
	      render 'new'
	    end
  	end

end

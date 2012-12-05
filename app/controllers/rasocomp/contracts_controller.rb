class Rasocomp::ContractsController < Rasocomp::ApplicationController
	before_filter :manager_or_user_self, :only => [:show]
	before_filter :manager, :only => [:edit, :update, :new, :create]
	
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
	    	redirect_to company_user_path @company.id, @user
	    else
	    	render 'edit'
	    end
  	end

  	def new
  		@company = Company.find(params[:company_id])
		@user = @company.users.find(params[:user_id])
		@contract = @user.contracts.build
  	end

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

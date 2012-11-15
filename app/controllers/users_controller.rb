class UsersController < ApplicationController

  def index
    @users = Company.find( params[:company_id]).users
  end

  def edit
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.update_attributes( params[ :user])
      redirect_to company_users_path
    else
      render 'edit'
    end
  end

  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.build
  end

  def create
    @company = Company.find( params[:company_id])
    @user = @company.users.build( params[:user])
    @user.role = 0
    @user.state = 0
    if @user.save
      redirect_to company_users_path
    else
      render 'new'
    end
  end

end

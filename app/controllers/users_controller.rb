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
    if @user.state==-1
      @user.state=1
    end
    if @user.update_attributes( params[:user])
      redirect_to company_path @company.id
    else
      render 'edit'
    end
  end

  def verify
    if !params[:token] || !params[:company_id]
      redirect_to root_path
    else
      @company = Company.find(params[:company_id])
      @user = User.find_by_remember_token(params[:token])
      if @user.nil? || @user.company_id != @company.id
        flash[:error] = "ERROOOOOOOOOOOOOO"
        redirect_to company_path @company
      end
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

class UsersController < ApplicationController

  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end

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
    if @user.update_attributes( params[:user])
      redirect_to company_path @company.id
    else
      render 'edit'
    end
  end

  def activate
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.state == -1
      @user.state = 1
    end
    if @user.update_attributes( params[:user])
      flash[:success] = t(:account_activated)
      redirect_to company_path @company.id
    else
      render 'verify'
    end
  end

  def verify
    if !params[:token] || !params[:company_id]
      flash[:error] = t(:invalid_verification)
      redirect_to root_path
    else
      @company = Company.find(params[:company_id])
      @user = @company.users.find_by_remember_token(params[:token])

      if @user.nil? || @user.state != -1
        flash[:error] = t(:invalid_verification)
        redirect_to root_path
      end
    end
  #    @company = Company.find(params[:company_id])
  #    @user = User.find(params[:user_id])

  end

  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.build
    @roles = [[ "DEUS JUST FOR DEBUG !", 0], [ "GESTOR", 1], [ "Colaborador", 2], [ "Escravo", 3]]
  end

  def create
    @roles = [[ "DEUS JUST FOR DEBUG !", 0], [ "GESTOR", 1], [ "Colaborador", 2], [ "Escravo", 3]]
    @company = Company.find( params[:company_id])
    @user = @company.users.build( params[:user])
    @user.role = Integer params[:role] unless !params[:role]
    @user.state = -1
    @user.password_digest = 0
    if @user.save
      UserMailer.verification_email(@user).deliver
      redirect_to company_users_path
    else
      render 'new'
    end
  end

end

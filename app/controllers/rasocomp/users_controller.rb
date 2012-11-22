class Rasocomp::UsersController < Rasocomp::ApplicationController
  #before_filter :super_user_or_manager_or_root, :only => [:new, :create, :index]
  #before_filter :super_user_or_manager_or_user_self, :only => [:show, :edit, :update, :dashboard]
  #before_filter :super_user_or_manager, :only => [:index]

  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @users = @company.users
  end

  def edit
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.update_attributes( params[:user])
      redirect_to company_user_path @company.id, @user
    else
      render 'edit'
    end
  end

  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.build
    @roles = ROLE
  end

  def create
    @roles = ROLE
    @company = Company.find( params[:company_id])
    role = params[:user][:role]
    params[:user].delete(:role)
    @user = @company.users.build( params[:user])
    @user.role = Integer role
    @user.state = -1
    @user.password_digest = 0
    if @user.save
      UserMailer.verification_email(@user).deliver
      redirect_to company_users_path
    else
      render 'new'
    end
  end

  def dashboard
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end

  private
    def super_user_or_manager_or_root
      comp = Company.find(params[:company_id])
      redirect_to company_signin_path(comp), notice: t(:no_permission_to_access) unless manager_signed_in?(comp.tag) || root_signed_in?(comp.tag) || super_user_signed_in?
    end

  private
    def super_user_or_manager_or_user_self
      comp = Company.find(params[:company_id])
      redirect_to company_signin_path(comp), notice: t(:no_permission_to_access) unless manager_signed_in?(comp.tag) || super_user_signed_in? || (user_signed_in?(comp.tag) && current_user(comp.tag).id == Integer(params[:id]))
    end

  private
    def super_user_or_manager
      comp = Company.find(params[:company_id])
      redirect_to company_signin_path(comp), notice: t(:no_permission_to_access) unless manager_signed_in?(comp.tag) || super_user_signed_in?
    end
end

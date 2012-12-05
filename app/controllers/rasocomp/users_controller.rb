class Rasocomp::UsersController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:new, :create, :index]
  before_filter :manager_or_user_self, :only => [:show, :edit, :update]
  before_filter :user_self_not_root, :only => [:dashboard]

  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @users = @company.users.search(params[:search]).paginate(:page => params[:page], :per_page => 4)
    #where("role > 0").paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if !@user.authenticate(params[:current_password])
      flash[:alert] = t(:current_password_not_valid)
      render 'edit'
    else
      if @user.update_attributes( params[:user])
        redirect_to company_user_path @company.id, @user
      else
        render 'edit'
      end
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
    @user.time_off_days = 0
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
end

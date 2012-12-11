class Rasocomp::UsersController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:new, :create, :index]
  before_filter :user_self_not_root, :only => [:dashboard]
  before_filter :manager_or_user_self, :only => [:show, :edit, :update]
  before_filter :user_self, :only => [:edit_password, :update_password]

  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @contracts = @user.contracts
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

  def add_credits_to_all
    @company = Company.find( params[:company_id] )
    @user = @company.users
  end
  
  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
    if @user.update_attributes(params[:user])
      flash[:success] = t(:successful_update)
      redirect_to company_user_path @company, @user
    else
      render 'edit'
    end
  end

  def edit_password
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  def update_password
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
    if @user.authenticate(params[:change_password][:current_password])
      @user.password = params[:change_password][:new_password]
      @user.password_confirmation = params[:change_password][:new_password_confirmation]
      if @user.save
        flash[:success] = t(:password_updated)
        redirect_to company_user_path @company, @user
      else
        render 'edit_password'
      end
    else
      flash.now[:alert] = t(:current_password_not_valid)
      render 'edit_password'
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
      
      period = @user.periods.build
      period.start_date = Date.today
      period.state = STATE[:unchecked]
      period.save
      
      redirect_to company_users_path
    else
      render 'new'
    end
  end

  def dashboard
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @contract = @user.contracts.order("end_date DESC").first
    if !@contract.nil? 
      @contracts = @user.contracts.order("end_date DESC").where("id != ?", @contract.id)
    end
  end
end

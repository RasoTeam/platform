# == User Controller
#  Controller used to manage employees inside a company
class Rasocomp::UsersController < Rasocomp::ApplicationController
  before_filter :manager_or_root, :only => [:new, :create, :index, :resend_verification_email, :activate_account, :deactivate_account]
  before_filter :user_self_not_root, :only => [:dashboard]
  before_filter :manager_or_user_self, :only => [:show, :edit, :update]
  before_filter :user_self, :only => [:edit_password, :update_password]

  # Shows employee details. Availabe to own employee and manager
  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @contracts = @user.contracts.order("end_date DESC")
  end

  # Lists all employees in a company. Available to root and managers
  def index
    @company = Company.find(params[:company_id])
    @users = @company.users.search(params[:search]).paginate(:page => params[:page], :per_page => 15)
    #where("role > 0").paginate(:page => params[:page], :per_page => 5)
  end

  # Edit an employee. Available to the own user and managers
  def edit
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  # Updates available credits for the employees
  def update_credits_to_all
    @company = Company.find( params[:company_id] )
    if params[:time_off_days] =~ /^\d+$/ 
      num = Integer(params[:time_off_days])
      @company.users.update_all ["time_off_days = ?", num]
      flash[:success] = t(:successful_update)
      redirect_to company_users_path @company
    else
      flash[:alert] = t(:not_a_number)
      redirect_to company_users_path @company
    end
  end
  
  # Updates employee data. Available to the own employee and managers.
  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
    if @user.update_attributes(params[:user])
      I18n.locale = current_user(@company.slug).locale
      flash[:success] = t(:successful_update)
      redirect_to company_user_path @company, @user
    else
      render 'edit'
    end
  end

  # Edit user password. Only available to own user.
  def edit_password
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  # Updates user password. Only available to own user.
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

  # New employee. Only avaible to managers and root.
  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.build
    @roles = ROLE
  end

  # Creates a new employee. Only avaible to managers and root.
  def create
    @roles = ROLE
    @company = Company.find( params[:company_id])
    role = params[:user][:role]
    params[:user].delete(:role)
    @user = @company.users.build( params[:user])
    @user.role = Integer role
    @user.time_off_days = 0
    @user.state = STATE[:unchecked]
    @user.password_digest = 0
    @user.locale = I18n.locale
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

  # Used to show information in the employee dashboard.d
  def dashboard
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @contract = @user.contracts.order("end_date DESC").first
    if !@contract.nil? 
      @contracts = @user.contracts.order("end_date DESC").where("id != ?", @contract.id)
    end
  end

  # Used to request a new verification email for a specific user.
  def resend_verification_email
    company = Company.find(params[:company_id])
    user = company.users.find(params[:id])
    UserMailer.verification_email(user).deliver
    flash[:success] = t(:email_resent)
    redirect_to company_users_path company
  end

  # Used to activate an account. It can be when the user confirms his email address or when a manager activates it (if it was previously deactivated)
  def activate_account
    company = Company.find(params[:company_id])
    user = company.users.find(params[:id])
    user.state = STATE[:active]
    if user.save

      period = user.periods.build
      period.start_date = Date.today
      period.state = STATE[:active]
      period.save

      flash[:success] = t(:activated_successfully)
      redirect_to company_users_path company
    else
      flash[:error] = t(:error)
      redirect_to company_users_path company
    end
  end

  # Used to desactivate an account by the manager. 
  def deactivate_account
    company = Company.find(params[:company_id])
    user = company.users.find(params[:id])
    user.state = STATE[:inactive]
    if user.save

      period = user.periods.build
      period.start_date = Date.today
      period.state = STATE[:inactive]
      period.save

      flash[:success] = t(:deactivated_successfully)
      redirect_to company_users_path company
    else
      flash[:error] = t(:error)
      redirect_to company_users_path company
    end
  end
end

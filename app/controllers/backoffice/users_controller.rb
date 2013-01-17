# == Users Controller
#  User controller for the backoffice. Allos to manage user data (Employees)
class Backoffice::UsersController < Backoffice::ApplicationController
  
  # Show an user
  def show
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end

  # Lists all users for a company
  def index
    @company = Company.find(params[:company_id])
    @users = @company.users.where("role > 0").paginate(:page => params[:page], :per_page => 15)
  end

  # Edit an user in a company
  def edit
    @company = Company.find( params[:company_id] )
    @user = @company.users.find( params[:id])
  end

  # Update user information
  def update
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.update_attributes( params[:user])
      redirect_to backoffice_company_user_path @company.id, @user
    else
      render 'edit'
    end
  end

  # Prepares to creates a new user in a company
  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.build
    @roles = ROLE
  end

  # Creates a new user for a company
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
      redirect_to backoffice_company_user_path @company.id, @user
    else
      render 'new'
    end
  end

  # Show user dashboard
  def dashboard
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
  end
end

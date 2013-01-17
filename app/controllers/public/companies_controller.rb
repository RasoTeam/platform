# == Company Controller
#  Company controller for visitors
class Public::CompaniesController < Public::ApplicationController

  # New company
  def new
    @company = Company.new
    @user = @company.users.build
  end

  # Creates a company and a root user. Root user is used to keep the company email.
  def create
    @company = Company.new
    @company.name = params[:new_company][:name]
    @company.slug = @company.name.parameterize
    @company.state = COMPANY_STATE[:unchecked]
    @user = User.new
    if @company.save
      @user = @company.users.build
      @user.email = params[:new_company][:email]
      @user.name = t(:root)
      @user.state = STATE[:unchecked]
      @user.role = ROOT
      @user.password_digest = 0
      if @user.save
        UserMailer.verification_email(@user).deliver
        flash[:success] = t(:company_account_created)
        redirect_to company_signin_path @company.id
      else
        @company.destroy
        render 'new'
      end
    else
      render 'new'
    end
  end

  # Used to get the company when it is blocked. It is used to show the company name
  def company_blocked
    @company = Company.find(params[:company_id])
  end

  # Request password reset
  def reset_pass_require
    @company = Company.find(params[:company_id])
  end

  # Sumbit a password reset request
  def submit_pass_require
    @company = Company.find(params[:company_id])
    user = @company.users.find_by_email(params[:user_email][:email])
    if user.nil?
      flash.now[:alert] = t(:user_not_exists)
      render 'reset_pass_require'
    else
      if user.save
        UserMailer.reset_password(user).deliver
        flash[:success] = t(:email_sent)
        redirect_to company_signin_path @company
      else
        flash.now[:alert] = t(:error)
        render 'reset_pass_require'
      end
    end
  end

  # Used when a user is bloqued. It is used to show the company name
  def user_blocked
    @company = Company.find(params[:company_id])
  end

end

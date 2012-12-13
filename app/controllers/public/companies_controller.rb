class Public::CompaniesController < Public::ApplicationController

  def new
    @company = Company.new
    @user = @company.users.build
  end

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

  def company_blocked
    @company = Company.find(params[:company_id])
  end

  def reset_pass_require
    @company = Company.find(params[:company_id])
  end

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

  def user_blocked
    @company = Company.find(params[:company_id])
  end

end

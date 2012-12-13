class Public::UsersController < Public::ApplicationController
	def activate
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.state == STATE[:unchecked]
      
      period = @user.periods.build
      period.start_date = Date.today
      period.state = STATE[:active]
      period.save

      @user.state = STATE[:active]

      if @user.role == ROOT
        @company.state = COMPANY_STATE[:active]
        @company.save
      end
      
    end
    @user.remember_token = SecureRandom.urlsafe_base64
    if @user.update_attributes( params[:user])
      flash[:success] = t(:account_activated)
      redirect_to company_signin_path @company
    else
      render 'verify'
    end
  end

  def verify
    if !params[:token] || !params[:company_id]
      flash[:alert] = t(:invalid_verification)
      redirect_to root_path
    else
      @company = Company.find(params[:company_id])
      @user = @company.users.find_by_remember_token(params[:token])

      if @user.nil? || @user.state != STATE[:unchecked]
        flash[:alert] = t(:invalid_verification)
        redirect_to root_path
      end
    end
  end

  def reset_new_password
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    if !@user || @user.remember_token != params[:token]
      flash[:alert] = t(:error)
      redirect_to company_signin_path @company
    end
  end

  def reset_password_submit
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @user.remember_token = SecureRandom.urlsafe_base64
    if @user.update_attributes( params[:user])
      flash[:success] = t(:password_updated)
      redirect_to company_signin_path @company
    else
      render 'reset_new_password'
    end
  end

end

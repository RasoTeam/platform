class Public::UsersController < Public::ApplicationController
	def activate
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:id])
    if @user.state == -1
      
      period = @user.periods.build
      period.start_date = Date.today
      period.state = STATE[:active]
      period.save

      @user.state = 1

      if @user.role == ROOT
        @company.state = COMPANY_STATE[:active]
        @company.save
      end
    end
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

      if @user.nil? || @user.state != -1
        flash[:alert] = t(:invalid_verification)
        redirect_to root_path
      end
    end
  end
end

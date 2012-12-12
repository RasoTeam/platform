class Public::CompaniesController < Public::ApplicationController

  def new
    @company = Company.new
    @user = @company.users.build
  end

  def create
    @company = Company.new
    @company.name = params[:new_company][:name]
    @company.slug = @company.name.parameterize
    @company.state = 0;
    @user = User.new
    if @company.save
      @user = @company.users.build
      @user.email = params[:new_company][:email]
      @user.name = 'root'
      @user.state = -1
      @user.role = 0
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

end

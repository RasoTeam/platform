class Public::CompaniesController < Public::ApplicationController
  def show
    @company = Company.find_by_slug(request.subdomain)
    redirect_to company_signin_path(@company)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new
    @company.name = params[:new_company][:name]
    @company.slug = params[:new_company][:slug]
    @company.state = 0;
    if @company.save
      user = @company.users.build
      user.email = params[:new_company][:email]
      user.name = 'root'
      user.state = -1
      user.role = 0
      user.password_digest = 0
      if user.save
        UserMailer.verification_email(user).deliver
        redirect_to company_signin_path @company.id
      else
        render 'new'
      end
    else
      render 'new'
    end
  end
end

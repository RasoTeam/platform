class Public::CompaniesController < Public::ApplicationController
  def show
    company = Company.find_by_tag(request.subdomain)
    redirect_to company_signin_path company
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new( params[:company])
    @company.state = 0;
    if @company.save
      user = @company.users.build
      user.name = 'root'
      user.email = @company.email
      user.state = -1
      user.role = 0
      user.password_digest = 0
      user.save
      UserMailer.verification_email(user).deliver
      redirect_to company_signin_path @company.id
    else
      render 'new'
    end
  end
end

class CompaniesController < ApplicationController

  def index
    if super_user_signed_in?
      @companies = Company.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 10)
    else 
      redirect_to root_path, notice: t(:no_permission_to_access)
    end
  end

  def show
    @companies = Company.search(nil, params[:order]).paginate(:page => params[:page], :per_page => 10)
    @company = Company.find(params[:id])
    @bills = @company.bills
  end

  def edit
    @company = Company.find( params[:id])
  end

  def update
    @company = Company.find( params[:id])
    if @company.update_attributes(params[ :company])
      redirect_to edit_company_path @company.id
    else
      render 'edit'
    end
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
      redirect_to company_path @company.id
    else
      render 'new'
    end
  end
end

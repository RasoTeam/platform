class Rasocomp::CompaniesController < Rasocomp::ApplicationController
  #before_filter :super_user_or_manager_or_root, :only => [:show, :edit, :update]
  #before_filter :super_user_only, :only => :index

  def index
    @companies = Company.search(params[:search], params[:order]).paginate(:page => params[:page], :per_page => 10)
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
      flash[:success]= t(:successful_update)
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

  private
    def super_user_or_manager_or_root
      @comp = Company.find(params[:id])
      redirect_to company_signin_path(@comp), notice: t(:no_permission_to_access) unless manager_signed_in?(@comp.tag) || root_signed_in?(@comp.tag) || super_user_signed_in?
    end

  private
    def super_user_only
      redirect_to supersignin_path, notice: t(:no_permission_to_access) unless super_user_signed_in?
    end
end

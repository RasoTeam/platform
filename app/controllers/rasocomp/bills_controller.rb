class Rasocomp::BillsController < Rasocomp::ApplicationController
  #before_filter :super_user_or_manager, :only => [:show, :index]
  #before_filter :super_user_only, :only => :show_all

  def show
    @bill = Company.find(params[:company_id]).bills.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) 
  end

  def show_all
      @bills = Bill.search(params[:search], params[:order], params[:filt]).paginate(:page => params[:page], :per_page => 4)
  end

  private
    def super_user_or_manager
      @comp = Company.find(params[:company_id])
      redirect_to company_signin_path(params[:company_id]), notice: t(:no_permission_to_access) unless manager_signed_in?(@comp.tag) || super_user_signed_in?
    end

  private
    def super_user_only
      redirect_to supersignin_path, notice: t(:no_permission_to_access) unless super_user_signed_in?
    end
end

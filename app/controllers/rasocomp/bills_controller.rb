class Rasocomp::BillsController < Rasocomp::ApplicationController
  before_filter :manager_or_root

  def show
    @bill = Company.find(params[:company_id]).bills.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) 
  end

  private
    def manager_or_root
      comp = Company.find(params[:id])
      unless manager_signed_in?(comp.tag) || root_signed_in?(comp.tag)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end
end


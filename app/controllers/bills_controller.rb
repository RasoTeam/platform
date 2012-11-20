class BillsController < ApplicationController
  def show
    @bill = Bill.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4)
  end

  def show_all
    if super_user_signed_in?
      order = params[:order]
      order ||= "DESC"

      filt = params[:filt]
      filt ||= ">= 0"
      
      @bills = Bill.order("created_at "+order).where("state "+filt).paginate(:page => params[:page], :per_page => 4)
    else
      redirect_to root_path, notice: t(:no_permission_to_access)
    end
  end
end

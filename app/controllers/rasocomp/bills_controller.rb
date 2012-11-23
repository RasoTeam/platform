class Rasocomp::BillsController < Rasocomp::ApplicationController

  def show
    @bill = Company.find(params[:company_id]).bills.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 4) 
  end
end

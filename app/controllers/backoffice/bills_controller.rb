class Backoffice::BillsController < Backoffice::ApplicationController
  def show
    @bill = Company.find(params[:company_id]).bills.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 15) 
  end

  def show_all
      @bills = Bill.search(params[:search], params[:order], params[:filt]).paginate(:page => params[:page], :per_page => 15)
  end
end

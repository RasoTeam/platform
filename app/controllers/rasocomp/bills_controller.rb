# == Bill Controller
#  Controller to manage bills in a company. Only accessible for managers and roots users.
class Rasocomp::BillsController < Rasocomp::ApplicationController
  before_filter :manager_or_root

  # Shows a bill for a company
  def show
    @company = Company.find(params[:company_id])
    @bill = @company.bills.find(params[:id])
  end

  # Returns all bills for a company
  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 15) 
  end
end

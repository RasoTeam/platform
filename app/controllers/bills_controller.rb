class BillsController < ApplicationController
  def show
    @bill = Bill.find(params[:id])
  end

  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills
  end
end

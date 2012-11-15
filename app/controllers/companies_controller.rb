class CompaniesController < ApplicationController

  def index
    @companies = Company.order("name").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @company = Company.find(params[:id])
    @bills = @company.bills
  end

  def edit
    @company = Company.find( params[:id])
  end

  def update
    @company = Company.find( params[:id])
    if @company.update_attributes( params[ :company])
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
      redirect_to new_company_user_path @company.id
    else
      render 'new'
    end
  end
end

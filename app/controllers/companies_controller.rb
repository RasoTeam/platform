class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @company = Company.new( params[:company])
    @company.state = 0;
    if @company.save
      redirect_to new_user_path
    else
      render 'new'
    end
  end
end

class Rasocomp::ParametersController < ApplicationController

  def index
    @parameters = Parameter.all
  end


  def new
    @parameter = Parameter.new
    @company = Company.find(params[:company_id])
  end

  def create
    @parameter = Parameter.new(params[:parameter])
    @company_id = params[:company_id]

    if @parameter.save
      flash[:success] = "Evaluation Parameter successfully added."
      redirect_to new_company_evaluation_path(@company_id)
    else
      flash[:error] = "Could not save parameter"
      redirect_to company_parameters_path(@company_id)
    end

  end

  def show
  end
end

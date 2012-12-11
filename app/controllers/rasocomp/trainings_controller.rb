class Rasocomp::TrainingsController < ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings
  end

  def new
    @company = Company.find( params[:company_id])
    @training = @company.trainings.build
  end

  def create
    @company = Company.find( params[:company_id])
    @training = @company.trainings.build( params[:training])
    if @training.save
      redirect_to company_trainings_path( params[:company_id])
    else
      render 'new'
    end
  end
end

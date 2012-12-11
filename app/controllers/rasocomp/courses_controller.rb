class Rasocomp::CoursesController < ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings.find( params[:training_id])
    @courses = @trainings.courses
  end
  
  def activate
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    course = Course.find( params[:id])
    if course.state == 0
      course.update_attribute :state, 1
    end
    
    redirect_to company_trainings_path( params[:company_id])
  end
  
  def new
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = @training.courses.build
  end

  def edit
    @company = Company.find( params[:company_id])
    @training = Training.find( params[:training_id])
    @course = Course.find( params[:id])
  end

  def create
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = @training.courses.build( params[:course])
    @course.state = 0
    if @course.save
      redirect_to company_trainings_path( params[:company_id])
    else
      render 'new'
    end
  end
  
  def destroy
    course = Course.find( params[:id])
    course.destroy
    redirect_to company_trainings_path( params[:company_id])
  end
end

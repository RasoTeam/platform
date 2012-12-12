class Rasocomp::TrainingsController < ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings
    @current_user_id = current_user( @company.slug).id
    @training_course = []
    @trainings.each do |t|
      training_courses = t.courses
      @training_course << [ t, 
                            training_courses.select { |c| c.category == 1 || (c.users.collect { |u| u.id}.include? @current_user_id) } , 
                            true
                          ]
    end
  end
  
  def manage
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
      redirect_to manage_company_trainings_path( params[:company_id])
    else
      render 'new'
    end
  end
end

class Rasocomp::CoursesController < ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings.find( params[:training_id])
    #@courses = @trainings.courses
  end
  
  def activate
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    course = Course.find( params[:id])
    if course.state == 0
      course.update_attribute :state, 1
    end
    
    redirect_to manage_company_trainings_path( params[:company_id])
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
    #ALL USERS EXCEPT ROOT (role != 0) AND INACTIVE USERS state == 0
    @users = @company.users.find( :all, :conditions => ["role != ? AND state == ?", 0, 1])
  end
  
  def update
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = Course.find( params[:id])
    if @course.update_attributes(params[:course])
      flash[:success] = t(:successful_update)
      redirect_to manage_company_trainings_path @company
    else
      render 'edit'
    end
  end

  def update_users
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = Course.find( params[:id])
    @users_to_add = params[:users]
    #@course.users.clear
    #if !@users_to_add.nil?
    #  @users_to_add.each do |u_id|
    #    @course.users << User.find( u_id)
    #  end
    #end
    @course.course_signups.delete_all
    if !@users_to_add.nil?
      @users_to_add.each do |u_id|
        signup = @course.course_signups.build
        signup.user_id = u_id
        signup.status = 0
        signup.save
      end
    end
    redirect_to manage_company_trainings_path @company
  end
  
  def enroll
    company = Company.find( params[:company_id])
    current_user_id = current_user( company.slug).id
    #user = User.find( current_user_id)
    course = Course.find( params[:id])
    if course.category == 1
      #public auto add user
      signup = course.course_signups.build
      signup.user_id = current_user_id
      signup.status = 1
      signup.save
      #course.users << user
    else
      #private set status to 1
      signup = course.course_signups.find_by_user_id( current_user_id)
      signup.status = 1
      signup.save
    end
    redirect_to company_trainings_path( company.slug)
  end
  
  def unenroll
    company = Company.find( params[:company_id])
    current_user_id = current_user( company.slug).id
    #user = User.find( current_user_id)
    course = Course.find( params[:id])
    if course.category == 1
      #course.users.delete(user)
      signup = course.course_signups.find_by_user_id( current_user_id)
      signup.destroy
    else
      signup = course.course_signups.find_by_user_id( current_user_id)
      signup.status = 0
      signup.save
    end
    redirect_to company_trainings_path( company.slug)
  end
  
  def create
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = @training.courses.build( params[:course])
    @course.state = 0
    if @course.save
      redirect_to manage_company_trainings_path( params[:company_id])
    else
      render 'new'
    end
  end
  
  def destroy
    course = Course.find( params[:id])
    course.destroy
    redirect_to manage_company_trainings_path( params[:company_id])
  end
end

# == Course Controller
#  Controller used to manage training courses.
class Rasocomp::CoursesController < ApplicationController

layout 'rasoemp'

  # Lists all courses in a training programme
  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings.find( params[:training_id])
    # - @courses = @trainings.courses
  end
  
  # Activates a course for training programme in a company.
  def activate
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    course = Course.find( params[:id])
    if course.state == 0
      course.update_attribute :state, 1
    end
    
    redirect_to training_courses_manage_path(@company,@training)
  end
  
  # New course for a training programme in a company.
  def new
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = @training.courses.build
  end

  # Edit a course for a training programme in a company.
  def edit
    @company = Company.find( params[:company_id])
    @training = Training.find( params[:training_id])
    @course = Course.find( params[:id])
    #ALL USERS EXCEPT ROOT (role != 0) AND INACTIVE USERS state == 0
    @users = @company.users.find( :all, :conditions => ["role != ? AND state == ?", ROOT, STATE[:active]])
  end
  
  # Update a course for a training programme in a company.
  def update
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = Course.find( params[:id])
    if @course.update_attributes(params[:course])
      flash[:success] = t(:successful_update)
      redirect_to training_courses_manage_path @company, @training
    else
      puts @course.errors.full_messages
      render 'edit'
    end
  end

  # Update users enrolled for a course in a trainning programme
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
  
  # Used for an user to enroll in a course for a training programme
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
  
  # Used for users to resign a course programme
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
  
  # Creates a course for a training programme
  def create
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @course = @training.courses.build( params[:course])
    @course.state = 0
    if @course.save
      redirect_to training_courses_manage_path( @company,@training)
    else
      render 'new'
    end
  end
  
  # Removes a course from a training programme
  def destroy
    course = Course.find( params[:id])
    course.destroy
    redirect_to training_courses_manage_path( params[:company_id],params[:training_id])
  end

  # Return all courses for a training programme in a company
  def manage
    @company = Company.find( params[:company_id])
    @training = @company.trainings.find( params[:training_id])
    @courses = @training.courses
  end 

end


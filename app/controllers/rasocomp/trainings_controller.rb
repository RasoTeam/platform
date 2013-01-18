# == Training Programmes Controller
#  Controller used to manage training programmes
class Rasocomp::TrainingsController <  Rasocomp::ApplicationController

  # Lists all training programmes as well as a link to show a specific training program details
  def index
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings
    @current_user_id = current_user( @company.slug).id
    @training_course = []
    @trainings.each do |t|
      training_courses = t.courses
      courses_pair = []
      training_courses.each do |c|
        if c.category == 1 || (c.course_signups.collect { |u| u.user.id}.include? @current_user_id)
          courses_pair << [ c, c.course_signups.find( :all, :conditions => ['user_id = ? AND status = ?', @current_user_id, 1]).any?]
        end
      end
      
      @training_course << [ t,
                            courses_pair ]
      #training_courses.select { |c| c.category == 1 || (c.course_signups.collect { |u| u.user.id}.include? @current_user_id) } , 
    end
  end
  
  # Lists all training programmes
  def manage
    @company = Company.find( params[:company_id])
    @trainings = @company.trainings
  end

  # New training programme
  def new
    @company = Company.find( params[:company_id])
    @training = @company.trainings.build
  end

  # Creates a new training programme
  def create
    @company = Company.find( params[:company_id])
    @training = @company.trainings.build( params[:training])
    if @training.save
      redirect_to manage_company_trainings_path( params[:company_id])
    else
      render 'new'
    end
  end

  # Deletes a training programme
  def destroy
    company = Company.find(params[:company_id])
    company.trainings.find(params[:id]).destroy
    flash[:success] = 'Training Deleted'

    redirect_to manage_company_trainings_path(company)
  end
end

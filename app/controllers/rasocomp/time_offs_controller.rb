# == Time Offs Controller
#  Controller to manage time offs in a company
class Rasocomp::TimeOffsController < Rasocomp::ApplicationController

  # Lits all time offs for an employee in a company
  def index
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoffs = @user.time_offs #TimeOff.find_by_user_id( params[:user_id])
  end

  # Lists all time offs for an employee in a company
  def manage
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoffs = @company.time_offs
  end

  # Used by the manager to approve a time off request
  def approve
    @company = Company.find( params[:company_id])
    #@user = @company.users.find( params[:user_id])
    #@timeoff = @user.time_offs.find( params[:id])
    @timeoff = TimeOff.find( params[:id])
    #@user = @user.find( @timeoff.user_id)
    if @timeoff.state == 2
      user_t = User.find( @timeoff.user_id)
      user_t.time_off_days -= @timeoff.total_credits
      user_t.save!(:validate => false)
    end
    @timeoff.update_attribute :state, 1
    @timeoff.update_attribute :color, '#33FF33'
    redirect_to manage_company_user_time_offs_path( @company, User.find( params[:user_id]))
    #redirect_to 
  end

  # Used by the manager to disapprove a time off request
  def disapprove
    company = Company.find( params[:company_id])
    #user = company.users.find( params[:user_id])
    #timeoff = user.time_offs.find( params[:id])
    timeoff = TimeOff.find( params[:id])
    if timeoff.state != 2
      user_t = User.find( timeoff.user_id)
      user_t.time_off_days += timeoff.total_credits
      user_t.save!(:validate => false)
    end
    timeoff.update_attribute :state, 2
    timeoff.update_attribute :color, '#330000'
    redirect_to manage_company_user_time_offs_path( company, User.find( params[:user_id]))
    #redirect_to root_path
  end

  # Change time off state to valid
  def set_state_to_valid
     
  end

  # Show time off details
  def show
    @timeoff = TimeOff.find( params[:id])
  end

  # New time off request
  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])

    #@timeoff = TimeOff.new
    @timeoff = @user.time_offs.build
  end

  # Creates a new time off request
  def create
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.build( params[:time_off])
    @timeoff.company_id = @company.id
    @timeoff.state = 0
    @timeoff.credits = @user.time_off_days
    @timeoff.color = '#B8B8B8'
    @timeoff.name = @user.name + " | " + TIMETYPE.invert[@timeoff.category].to_s
    @timeoff.valid?
    if @timeoff.save
      @user.time_off_days -= @timeoff.total_credits
      @user.save!(:validate => false)
      redirect_to company_user_time_offs_path( params[:company_id], params[:user_id])
    else
      render 'new'
    end
  end

  # Destroys a time off
  def destroy
    user = User.find( params[:user_id])
    timeoff = TimeOff.find( params[:id])
    if timeoff.state == 0 #only return credits if pending (0) or approved (1)
      user.time_off_days += timeoff.total_credits
      user.save!(:validate => false)
    end
    if timeoff.state != 1
      timeoff.destroy
    end
    redirect_to company_user_time_offs_path( params[:company_id], params[:user_id])
  end
end

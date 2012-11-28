class Rasocomp::TimeOffsController < Rasocomp::ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoffs = @user.time_offs #TimeOff.find_by_user_id( params[:user_id])
  end

  def manage
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoffs = @company.time_offs
  end

  def approve
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.find( params[:id])
    if @timeoff.state == 2
      user_t = User.find( @timeoff.user_id)
      user_t.time_off_days -= @timeoff.days
      user_t.save!(:validate => false)
    end
    @timeoff.update_attribute :state, 1
    @timeoff.update_attribute :color, '#33FF33'
    redirect_to manage_company_user_time_offs_path( @company, @user)
    #redirect_to 
  end

  def disapprove
    company = Company.find( params[:company_id])
    user = company.users.find( params[:user_id])
    timeoff = user.time_offs.find( params[:id])
    if timeoff.state != 2
      user_t = User.find( timeoff.user_id)
      user_t.time_off_days += timeoff.days
      user_t.save!(:validate => false)
    end
    timeoff.update_attribute :state, 2
    timeoff.update_attribute :color, '#330000'
    redirect_to manage_company_user_time_offs_path( company, user)
    #redirect_to root_path
  end

  def set_state_to_valid
     
  end

  def show
    @timeoff = TimeOff.find( params[:id])
  end

  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])

    #@timeoff = TimeOff.new
    @timeoff = @user.time_offs.build
  end

  def create
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.build( params[:time_off])
    @timeoff.company_id = @company.id
    @timeoff.state = 0
    @timeoff.credits = @user.time_off_days
    @timeoff.color = '#B8B8B8'
    @timeoff.name = "TIMEOFF:" + @user.name + ":" + @timeoff.category.to_s + ":" + @timeoff.description
    if @timeoff.save
      @user.time_off_days -= @timeoff.days
      @user.save!(:validate => false)
      redirect_to company_user_time_offs_path( params[:company_id], params[:user_id])
    else
      render 'new'
    end
  end

  def destroy
    user = User.find( params[:user_id])
    timeoff = TimeOff.find( params[:id])
    if timeoff.state != 2 #only return credits if pending (0) or approved (1)
      user.time_off_days += timeoff.days
      user.save!(:validate => false)
    end
    timeoff.destroy
    redirect_to company_user_time_offs_path( params[:company_id], params[:user_id])
  end
end

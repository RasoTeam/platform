class TimeOffsController < ApplicationController

  def index
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])

    @timeoffs = @user.time_offs #TimeOff.find_by_user_id( params[:user_id])
  end

  def manage
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoffs = TimeOff.all
  end

  def approve
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.find( params[:id])
  end

  def disapprove
    redirect_to root_path
  end

  def set_state_to_valid
    
  end

  def show
    @timeoffs = TimeOff.find( params[:id])
  end

  def new
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.build
  end

  def create
    @company = Company.find( params[:company_id])
    @user = @company.users.find( params[:user_id])
    @timeoff = @user.time_offs.build( params[:time_off])
    @timeoff.state = 0
    @timeoff.credits = @user.time_off_days
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
    user.time_off_days += timeoff.days
    user.save!(:validate => false)
    timeoff.destroy
    redirect_to company_user_time_offs_path( params[:company_id], params[:user_id])
  end
end

# == Super Users Controller
#  Super users controller for the backoffice
class Backoffice::SuperUsersController < Backoffice::ApplicationController
	before_filter :super_user_self, :only => [:edit, :update, :destroy]
	
	# List all super users
	def index
		@super_users = SuperUser.all
	end

	# Show super user information
	def show
		@super_user = SuperUser.find(params[:id])
	end
	
	# Edit a super user
	def edit
		@super_user = SuperUser.find(params[:id])
	end

	# Update a super user. Only accessible to the own super user
	def update
		@super_user = SuperUser.find(params[:id])

		if !@super_user.authenticate(params[:super_user][:current_password])
			@super_user.errors.add(:current_password, "is incorrect")
			render 'edit'
		else
			params[:super_user].delete(:current_password)		
		
			if @super_user.update_attributes(params[:super_user])
				redirect_to backoffice_super_user_path(@super_user)
			else
				render 'edit'
			end
		end
	end

	# Prepare to create new super user
	def new
		@super_user = SuperUser.new
	end

	# create a super user
	def create
		@super_user = SuperUser.new(params[:super_user])
		if @super_user.save
			redirect_to backoffice_super_user_path(@super_user)
		else
			render 'new'
		end
	end

	# Destroy a super user
	def destroy
		@super_user = SuperUser.find(params[:id])
		if @super_user.destroy
			redirect_to root_path
		else
			redirect_to backoffice_super_user_path(@super_user)
		end
	end

	# Calculates some stats about the current companies
	def stats
		if params[:year] != nil
			year = Integer(params[:year])
			final_year = year + 1
		else
			year=2012
			final_year=Date.today.year + 1
		end

		initial_date = DateTime.new(year)
		final_date = DateTime.new(final_year)

		@first_year = Company.first.created_at.year
		@current_year = Date.today.year
		@received = Bill.where(:created_at => initial_date..final_date).where("state = 1").sum("value")
		@debt = Bill.where(:created_at => initial_date..final_date).where("state = 0").sum("value")
		@nr_companies = Company.where(:created_at => initial_date..final_date).count

		if @nr_companies > 0
			@avg_users = User.where(:created_at => initial_date..final_date).count/@nr_companies
		else
			@avg_users = 0
		end
	end

	private
		# Used to check if it is the own user
		def super_user_self
			unless current_super_user.id == Integer(params[:id])
				flash[:alert] = t(:no_permission_to_access) 
				redirect_to backoffice_super_user_path(current_super_user)
			end
		end
end

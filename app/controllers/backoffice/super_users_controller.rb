class Backoffice::SuperUsersController < ApplicationController
	before_filter :super_user_only, :only => [:index, :show, :new, :create, :home]
	before_filter :super_user_self, :only => [:edit, :update, :destroy]
	
	def index
		@super_users = SuperUser.all
	end

	def show
		@super_user = SuperUser.find(params[:id])
	end
	
	def edit
		@super_user = SuperUser.find(params[:id])
	end

	def update
		@super_user = SuperUser.find(params[:id])

		if !@super_user.authenticate(params[:super_user][:current_password])
			@super_user.errors.add(:current_password, "is incorrect")
			render 'edit'
		else
			params[:super_user].delete(:current_password)		
		
			if @super_user.update_attributes(params[:super_user])
				redirect_to super_users_path
			else
				render 'edit'
			end
		end
	end

	def new
		@super_user = SuperUser.new
	end

	def create
		@super_user = SuperUser.new(params[:super_user])
		if @super_user.save
			redirect_to super_user_path(@super_user)
		else
			render 'new'
		end
	end

	def destroy
		@super_user = SuperUser.find(params[:id])
		if @super_user.destroy
			redirect_to super_users_path
		else
			redirect_back_or_to super_users_path
		end
	end

	def home
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
		def super_user_only
			redirect_to supersignin_path, notice: t(:no_permission_to_access) unless super_user_signed_in?
		end

	private
		def super_user_self
			redirect_to root_path, notice: t(:no_permission_to_access) unless super_user_signed_in? && current_super_user.id == Integer(params[:id])
		end
end

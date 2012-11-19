class SuperUsersController < ApplicationController
	
	def index
		if super_user_signed_in?
			@super_users = SuperUser.all
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def show
		if super_user_signed_in?
			@super_user = SuperUser.find(params[:id])
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end
	
	def edit
		if super_user_signed_in? && (current_super_user.id.to_s == params[:id])
			@super_user = SuperUser.find(params[:id])
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def update
		if super_user_signed_in? && (current_super_user.id.to_s == params[:id])
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
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def new
		if super_user_signed_in?
			@super_user = SuperUser.new
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def create
		if super_user_signed_in?
			@super_user = SuperUser.new(params[:super_user])
			if @super_user.save
				redirect_to super_user_path(@super_user)
			else
				render 'new'
			end
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def destroy
		if super_user_signed_in?
			@super_user = SuperUser.find(params[:id])
			if @super_user.destroy
				redirect_to super_users_path
			else
				redirect_back_or_to super_users_path
			end
		else
			redirect_to root_path, notice: t(:no_permission_to_access)
		end
	end

	def home
		@received = Bill.where("state = 1").sum("value")
		@debt = Bill.where("state = 0").sum("value")
		@nr_companies = Company.count
		if @nr_companies > 0
			@avg_users = User.count/@nr_companies
		else
			@avg_users = 0
		end
	end
end

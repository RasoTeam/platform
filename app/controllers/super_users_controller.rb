class SuperUsersController < ApplicationController
	
	def index
		if super_user_signed_in?
			@super_users = SuperUser.all
		else
			redirect_to root_path
		end
	end

	def show
		if super_user_signed_in?
			@super_user = SuperUser.find(params[:id])
		else
			redirect_to root_path
		end
	end
	
	def edit
		if super_user_signed_in? && (current_super_user.id.to_s == params[:id])
			@super_user = SuperUser.find(params[:id])
		else
			redirect_to root_path
		end
	end

	def update
		if super_user_signed_in? && (current_super_user.id.to_s == params[:id])
			@super_user = SuperUser.find(params[:id])
			if @super_user.update_attributes(params[:super_user])
				redirect_to super_users_path
			else
				render 'edit'
			end
		else
			redirect_to root_path
		end
	end

	def new
		if super_user_signed_in?
			@super_user = SuperUser.new
		else
			redirect_to root_path
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
			redirect_to root_path
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
			redirect_to root_path
		end
	end

end

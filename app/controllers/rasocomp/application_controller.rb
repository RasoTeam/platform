# == Companies employees controller
#  All others controllers extends from this controller
#  Only acessible for a user which is logged in the company
class Rasocomp::ApplicationController < ::ApplicationController
  before_filter :user_authentication
  before_filter :company_active
  layout "rasoemp"

private

  # Checks if user is authenticatedm in a specific company
  def user_authentication
    id = params[:company_id]
    id ||= params[:id]
    comp = Company.find(id)
    unless user_signed_in?(comp.slug)
    	flash[:alert] = t(:no_permission_to_access)
   	  redirect_to company_signin_path(comp)
   end
  end

  # Checks if a company is active
  def company_active
    id = params[:company_id]
    id ||= params[:id]
    comp = Company.find(id)
    unless comp.state == COMPANY_STATE[:active]
      redirect_to company_blocked_path comp
    end
  end

  # Checks if a user is logged in a company and if the user is root or manager
  def manager_or_root
    id = params[:company_id]
    id ||= params[:id]
    comp = Company.find(id)
    unless manager_signed_in?(comp.slug) || root_signed_in?(comp.slug)
      flash[:alert] = t(:no_permission_to_access) 
      redirect_to company_signin_path(comp)
    end
  end

  # Checks if a user is logged in and if the user is a manager or trying to access his own stuff
  def manager_or_user_self
    id = params[:company_id]
    id ||= params[:id]
    comp = Company.find(id)
    unless manager_signed_in?(comp.slug) || (user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id]) && current_user(comp.slug).role != ROOT)
      flash[:alert] = t(:no_permission_to_access) 
      redirect_to company_signin_path(comp)
    end
  end

  # Checks if a user is logged in and if the user is a manager
  def manager
    id = params[:company_id]
    id ||= params[:id]
    comp = Company.find(id)
    unless manager_signed_in?(comp.slug)
      flash[:alert] = t(:no_permission_to_access) 
      redirect_to company_signin_path(comp)
    end
  end

  # Checks if a user is trying to access is own stuff
  def user_self
    comp = Company.find(params[:company_id])
    unless user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id])
      flash[:alert] = t(:no_permission_to_access) 
      redirect_to company_path(comp)
    end
  end

  # Checks if a user is trying to access his own stuff and the user is not root
  def user_self_not_root
    comp = Company.find(params[:company_id])
    unless user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id]) && current_user(comp.slug).role != ROOT
      flash[:alert] = t(:no_permission_to_access) 
      redirect_to company_path(comp)
    end
  end
end
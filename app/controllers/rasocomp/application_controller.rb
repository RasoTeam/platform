class Rasocomp::ApplicationController < ::ApplicationController
  before_filter :user_authentication
  layout "rasoemp"

private
    def user_authentication
      id = params[:company_id]
      id ||= params[:id]
      comp = Company.find(id)
      unless user_signed_in?(comp.slug)
      	flash[:alert] = t(:no_permission_to_access)
     	  redirect_to company_signin_path(comp)
     end
    end

    def manager_or_root
      comp = Company.find(params[:company_id])
      unless manager_signed_in?(comp.slug) || root_signed_in?(comp.slug)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end

    def manager_or_user_self
      comp = Company.find(params[:company_id])
      unless manager_signed_in?(comp.slug) || (user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id]) && current_user(comp.slug).role != ROOT)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end


    def manager
      comp = Company.find(params[:company_id])
      unless manager_signed_in?(comp.slug)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end

    def user_self
      comp = Company.find(params[:company_id])
      unless user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id])
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_path(comp)
      end
    end

    def user_self_not_root
      comp = Company.find(params[:company_id])
      unless user_signed_in?(comp.slug) && current_user(comp.slug).id == Integer(params[:id]) && current_user(comp.slug).role != ROOT
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_path(comp)
      end
    end
end
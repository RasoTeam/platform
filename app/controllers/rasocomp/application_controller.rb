class Rasocomp::ApplicationController < ::ApplicationController
  before_filter :user_authentication
  layout "rasoemp"

private
    def user_authentication
      id = params[:company_id]
      id ||= params[:id]
      comp = Company.find(id)
      unless user_signed_in?(comp.tag)
      	flash[:alert] = t(:no_permission_to_access)
     	  redirect_to company_signin_path(comp)
     end
    end
end
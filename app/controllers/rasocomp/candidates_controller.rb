class Rasocomp::CandidatesController < Rasocomp::ApplicationController
  before_filter :manager_or_root

  def index
    @company = Company.find(params[:company_id])
    @offers = @company.job_offers
    @candidate = Candidate.new
  end

  def apply
    @offer = JobOffer.find(params[:id])
    @candidato = Candidate.new
  end

private
    def manager_or_root
      comp = Company.find(params[:id])
      unless manager_signed_in?(comp.tag) || root_signed_in?(comp.tag)
        flash[:alert] = t(:no_permission_to_access) 
        redirect_to company_signin_path(comp)
      end
    end

end

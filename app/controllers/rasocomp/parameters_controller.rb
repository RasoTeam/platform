# == Parameters Controller
#  Controllert to manage parameters in an evaluation process
class Rasocomp::ParametersController < Rasocomp::ApplicationController

  # Lists all parameters available for evaluations
  def index
    @parameters = Parameter.all
  end

  # New parameter for future evaluation process
  def new
    @parameter = Parameter.new
    @company = Company.find(params[:company_id])

    respond_to do |format|
          format.html # new.html.erb
          format.js
    end
  end

  # Creates a new parameter for future evaluation process
  def create
    @parameter = Parameter.new(params[:parameter])
    @company_id = params[:company_id]

    respond_to do |format|
      if @parameter.save
        format.js
        format.html{ flash[:success] = "Evaluation Parameter successfully added."
                     redirect_to new_company_evaluation_path(@company_id) }
      else
        format.html{flash[:error] = "Could not save parameter"
                    redirect_to company_parameters_path(@company_id)}
        format.js{}
      end
    end

  end

  # Shows a parameter 
  def show
  end
end

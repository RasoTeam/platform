class Rasocomp::ParametersController < Rasocomp::ApplicationController

  def index
    @parameters = Parameter.all
  end


  def new
    @parameter = Parameter.new
    @company = Company.find(params[:company_id])

    respond_to do |format|
          format.html # new.html.erb
          format.js
    end
  end

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

  def show
  end
end

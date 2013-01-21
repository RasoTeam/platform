class Rasocomp::ParametersController < Rasocomp::ApplicationController

  def index
    @parameters = Parameter.all
  end


  def new
    @parameter = Parameter.new
    @company = Company.find(params[:company_id])

    puts "PASSO POR AQUI"
    respond_to do |format|
          format.html # new.html.erb
          format.js
    end
  end

  def create
    @parameter = Parameter.new(params[:parameter])
    @company_id = params[:company_id]

    puts "POR AQUI TAMBEM"
    if @parameter.save
      respond_to do |format|
        format.js
        format.html{
            flash[:success] = "Evaluation Parameter successfully added."
            redirect_to new_company_evaluation_path(@company_id)
        }
      end
    else
      respond_to do |format|
        format.html{flash[:error] = "Could not save parameter"
        redirect_to company_parameters_path(@company_id)}
        format.js
      end
    end

  end

  def show
  end
end

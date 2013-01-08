class Rasocomp::EvaluationsController < Rasocomp::ApplicationController

  def index
    @company = Company.find(params[:company_id])
    @evaluations = @company.evaluations
  end

  def new
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.new
    @evaluation.company_id = @company.id
    @employees = @company.users
    @parameters = Parameter.all
  end

  def create
    @evaluation = Evaluation.new
    @data = params[:evaluation]
    #Preenchimento do Objecto, vai assim por causa do formato das datas
    @evaluation.description = @data["description"]
    @evaluation.status = "Active"
    @evaluation.user_id = @data["user_id"]
    @evaluation.period_begin = Date.new(@data["period_begin(1i)"].to_i,@data["period_begin(2i)"].to_i,@data["period_begin(3i)"].to_i)
    @evaluation.period_end = Date.new(@data["period_end(1i)"].to_i,@data["period_end(2i)"].to_i,@data["period_end(3i)"].to_i)
    @evaluation.company_id = Company.find(params[:company_id]).id

    #Preenchimento da tabela ponte...tem que haver um metodo mais simples...
    @users = Array.new
    params[:evaluatees][:user_id].each do |us|
       @users << User.find(us)
    end
    @evaluation.users = @users

    if @evaluation.save
      flash[:success] = "Evaluation created successfully"
      redirect_to company_evaluations_path(params[:company_id])
    else
      flash[:error] = "Problem saving evaluation"
      redirect_to new_company_evaluation_path(params[:company_id])
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.find(params[:id])
    @evaluator = User.find(@evaluation.user_id)
    @evaluatees = @evaluation.users
  end

end

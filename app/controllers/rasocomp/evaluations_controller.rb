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
    @parameters = Parameter.all(:order => 'name ASC')
    #evaluation_parameter = @evaluation.evaluation_parameters.build()
    evaluation_user_parameters = @evaluation.evaluation_user_parameters.build()
  end

  def create
    @evaluation = Evaluation.new
    @data = params[:evaluation]
    #Preenchimento do Objecto, vai assim por causa do formato das datas
    @evaluation.description = @data["description"]
    @evaluation.status = "Active"
    @evaluation.user_id = @data["user_id"]
    @evaluation.period_begin = Date.parse(@data[:period_begin])
    @evaluation.period_end = Date.parse(@data[:period_end])
    @evaluation.company_id = Company.find(params[:company_id]).id

    #Preenchimento da tabela ponte...tem que haver um metodo mais simples...
    @users = Array.new
    params[:evaluatees][:user_id].each do |us|
       @users << User.find(us)
    end
    @evaluation.users = @users

    #Preencher a tabela ponte Evaluation_User_Parameters

    @evalparams1 = Array.new
    params[:evaluation][:evaluation_user_parameters_attributes].values.each do |evp|
      if evp[:_destroy] == "1"  #Verifica que foram escolhidos.
        @evalparam = @evaluation.evaluation_user_parameters.build(evp)
        @evalparams1 << @evalparam
      end
    end

    @evalparams2 = Array.new
    @users.each do |user|
      @evalparams1.each do |evalp|
        @evp = evalp
        @evp.user_id = user.id
        @evalparams2 << @evp
      end
    end

    @evaluation.evaluation_user_parameters = @evalparams2

    #Acção de guardar efectivamente
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
    @eval_params = @evaluation.evaluation_parameters
  end

  def evaluate
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.find(params[:evaluation_id])
    @evaluator = User.find(@evaluation.user_id)
    @evaluatees = @evaluation.users
    @eval_params = @evaluation.evaluation_parameters
    @parameters = @eval_params.parameters
  end

end

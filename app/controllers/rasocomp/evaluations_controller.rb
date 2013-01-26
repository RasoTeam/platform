# == Evaluation Controller
#  Controller to manage Evaluations
class Rasocomp::EvaluationsController < Rasocomp::ApplicationController

  @@order = "ASC"
  @@status = "ALL"

  # Lists all evaluations programmes in a company
  def index
    @company = Company.find(params[:company_id])
    if params[:search]  #Se há pesquisa
      @search_string = params[:search].to_s
      respond_to do |format|
        format.html { @evaluations = @company.evaluations.where("user_id = ?",current_user(@company.slug).id.to_s).where("description LIKE '%" + @search_string + "%'").paginate(:page => params[:page], :per_page => 15)}
      end
    else
      if params[:status] #Se há status
        if params[:status] == 'ALL'
          @@status = "ALL"
          respond_to do |format|
            format.js  { @evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).order("description " + params[:order].to_s).paginate(:page => params[:page], :per_page => 15)}
            format.html    {@evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).paginate(:page => params[:page], :per_page => 15)}
          end
        else
          @@status = params[:status]
          respond_to do |format|
            format.js  { @evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s + " AND status = '" + @@status + "'").order("description " + params[:order].to_s).paginate(:page => params[:page], :per_page => 15)}
            format.html    {@evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).paginate(:page => params[:page], :per_page => 15)}
          end
        end
      elsif @@status == "ALL" #Se o status é TUDO
        respond_to do |format|
          format.js  { @evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).order("description " + params[:order].to_s).paginate(:page => params[:page], :per_page => 15)}
          format.html    {@evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).paginate(:page => params[:page], :per_page => 15)}
        end
      else
        respond_to do |format|
          format.js  { @evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s + " AND status = '" + @@status + "'").order("description " + params[:order].to_s).paginate(:page => params[:page], :per_page => 15)}
          format.html    {@evaluations = @company.evaluations.where("user_id = " + current_user(@company.slug).id.to_s).paginate(:page => params[:page], :per_page => 15)}
        end
      end
    end
  end

  # New evaluation programme in a company
  def new
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.new
    @evaluation.company_id = @company.id
    @employees = @company.users.where("role !=  0")
    @parameters = Parameter.all(:order => 'name ASC')
    #evaluation_parameter = @evaluation.evaluation_parameters.build()
    evaluation_user_parameters = @evaluation.evaluation_user_parameters.build()
  end

  # Creates a new evaluation programme in a company.
  # Includes:
  #  Description
  #  Start Day
  #  End Day
  #  Evaluator: The employee who is going to evaluate
  #  Evaluated Employees: The employees which are going to be evaluated by the evluator
  #  Evaluation Parameters and values: Indicates what are the evaluation parameters and their minimun and maximum evaluation value
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

    @users.each do |user1|
      puts "Este utilizador" + user1.id.to_s
    end

    #Preencher a tabela ponte Evaluation_User_Parameters

    @evalparams1 = Array.new

    #Itera pelos parametros declarados e multiplica os registos pelo numero de utilizadores avaliados
    params[:evaluation][:evaluation_user_parameters_attributes].values.each do |evp|
      if evp[:_destroy] == "1"  #Verifica que foram escolhidos.
        @users.each do |user| #para cada user cria registos dos parametros
          @evalparam = @evaluation.evaluation_user_parameters.build(evp)
          @evalparam.user_id = user.id
          @evalparams1 << @evalparam
        end
      end
    end

    @evaluation.evaluation_user_parameters = @evalparams1

    #Acção de guardar efectivamente
    if @evaluation.save
      flash[:success] = "Evaluation created successfully"
      redirect_to company_evaluations_path(params[:company_id])
    else
      flash[:error] = "Problem saving evaluation"
      redirect_to new_company_evaluation_path(params[:company_id])
    end
  end

  # Shows an evaluation details.
  def show
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.find(params[:id])
    @evaluator = User.find(@evaluation.user_id)
    @evaluatees = @evaluation.users

    @eval_user_params = @evaluation.parameters
    @eval_user_params.uniq! #Elimina duplicados
  end

  # Prepares to evaluate.
  def evaluate
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.find(params[:evaluation_id])
    @evaluator = User.find(@evaluation.user_id)

    @eval_users = @evaluation.users
    @eval_users_params = @evaluation.evaluation_user_parameters
  end

  def confirm_evaluation
    @company = Company.find(params[:company_id])
    @evaluation = Evaluation.find(params[:evaluation_id])

    @evaluation.status = "Closed"

    if @evaluation.save
      flash[:success] = "Evaluation has been closed."
      redirect_to company_evaluations_path(@company)
    else
      flash[:error] = "Problem closing Evaluation, please try again."
      redirect_to company_evaluations_path(@company)
    end

  end

  #Deletes an Evaluation
  def destroy
    @evaluation = Evaluation.find(params[:id])
    @company = Company.find(params[:company_id])

    if @evaluation.delete
      flash[:success] = "Evaluation has been deleted."
      redirect_to company_evaluations_path(@company)
    else
      flash[:error] = "Problem deleting Evaluation, please try again."
      redirect_to company_evaluations_path(@company)
    end
  end

end

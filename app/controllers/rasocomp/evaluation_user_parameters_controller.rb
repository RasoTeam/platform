# == Evaluation User Parameters Controller
class Rasocomp::EvaluationUserParametersController < ApplicationController

  # Updates evaluation parameter for an user
  def update
    @evaluation_user_parameter = EvaluationUserParameter.find(params[:id])
    @evaluation_user_parameter.result = params[:evaluation_user_parameter]["result"]

    respond_to do |format|

      if @evaluation_user_parameter.save
        format.js{
                  @parameter = Parameter.find(@evaluation_user_parameter.parameter_id)
                  @evp = @evaluation_user_parameter
                  }
        format.html{}
      else
        format.js
        format.html
      end

    end

  end
end

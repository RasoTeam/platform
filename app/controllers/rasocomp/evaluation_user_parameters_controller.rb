class Rasocomp::EvaluationUserParametersController < ApplicationController

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

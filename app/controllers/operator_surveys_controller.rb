# typed: false
class OperatorSurveysController < ApplicationController
  def new
    @operator_survey = OperatorSurvey.new
    authorize @operator_survey
  end

  def create
    @operator_survey = OperatorSurvey.new(operator_survey_params)
    @operator_survey.user_id = current_user.id
    @operator_survey.operator_id = current_user.operator.id
    @operator_survey.operator_email = current_user.email
    authorize @operator_survey

    if @operator_survey.save
      op = current_user.operator
      op.update(name: @operator_survey.space_name, square_footage: @operator_survey.square_footage)

      OperatorMailer.new_operator_survey(@operator_survey).deliver_later

      redirect_to wait_operator_surveys_path
    else
      render :new
    end
  end

  def wait
    authorize OperatorSurvey
  end

  private

  def operator_survey_params
    result = params.require(:operator_survey).permit(:square_footage, :location, :space_name, :number_of_members)
    result[:square_footage] = result[:square_footage].split(",").join().to_i
    result
  end
end
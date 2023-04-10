class AnswersController < ApiController

  before_action :authenticate_user

  def create
    answer = Answer.create(answer_params)
    render_resource_or_errors(answer)
  end

  private

  def answer_params
    permitted_attributes(Answer.new).merge(
        patron: current_user
    )
  end
end
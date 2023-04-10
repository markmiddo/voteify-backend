class Patron::QuestionsController < ApiController

  before_action :authenticate_user
  expose :questions, -> { Question.no_answered(current_user) }

  def index
    render_resources(questions, each_serializer: PatronQuestionSerializer)
  end
end

class QuestionsController < ApiController

  expose :questions, -> { Question.all }

  before_action :authenticate_user

  def index
    render_resources(questions)
  end
end

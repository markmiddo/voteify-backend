class AnswerPolicy < ApplicationPolicy

  def permitted_attributes
    %i(answer_value question_id patron_id)
  end
end
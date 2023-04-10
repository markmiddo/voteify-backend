# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :answer

  def answer
    answer = object.answers.where(patron_id: current_user.id).try(:take)
    { id: answer.id, answer_value: answer.answer_value } if answer.present?
  end
end

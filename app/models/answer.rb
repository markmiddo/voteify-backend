# == Schema Information
#
# Table name: answers
#
#  id           :bigint(8)        not null, primary key
#  answer_value :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  patron_id    :bigint(8)
#  question_id  :bigint(8)
#
# Indexes
#
#  index_answers_on_patron_id    (patron_id)
#  index_answers_on_question_id  (question_id)
#

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :patron
end

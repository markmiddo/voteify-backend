# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord

  has_many :answers, dependent: :destroy

  validates :text, presence: true

  def self.no_answered(current_user)
    joins('left join answers on answers.question_id = questions.id and answers.patron_id = ' + (current_user.id).to_s)
        .where(answers: { id: nil })
  end
end

# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PatronQuestionSerializer < ActiveModel::Serializer
  attributes :id, :text
end

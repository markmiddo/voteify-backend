# == Schema Information
#
# Table name: terms_and_conditions
#
#  id         :bigint(8)        not null, primary key
#  body       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TermsAndConditionSerializer < ActiveModel::Serializer
  attributes :title, :body
end

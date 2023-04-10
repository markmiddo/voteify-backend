# == Schema Information
#
# Table name: visitor_messages
#
#  id           :bigint(8)        not null, primary key
#  email        :string
#  message_text :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class VisitorMessageSerializer < ActiveModel::Serializer
  attributes :id, :email, :message_text
end

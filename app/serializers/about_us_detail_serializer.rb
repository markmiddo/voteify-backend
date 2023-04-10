# == Schema Information
#
# Table name: about_us_details
#
#  id         :bigint(8)        not null, primary key
#  body       :string
#  subtitle   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AboutUsDetailSerializer < ActiveModel::Serializer
  attributes :id, :subtitle, :body
end

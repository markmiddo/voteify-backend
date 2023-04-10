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

FactoryBot.define do
  factory :terms_and_condition do
    title { Faker::Lorem.sentence  }
    body { Faker::Lorem.sentence  }
  end
end

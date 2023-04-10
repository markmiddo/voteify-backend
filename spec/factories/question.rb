FactoryBot.define do
  factory :question do
    text { Faker::Lorem.question }
  end
end

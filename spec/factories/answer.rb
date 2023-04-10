FactoryBot.define do
  factory :answer do
    answer_value { Faker::Lorem.sentence  }
    association :question, factory: :question
    association :patron, factory: :patron
  end
end

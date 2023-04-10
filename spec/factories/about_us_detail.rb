FactoryBot.define do
  factory :about_us_detail do
    subtitle { Faker::Lorem.sentence  }
    body { Faker::Lorem.sentence  }
  end
end

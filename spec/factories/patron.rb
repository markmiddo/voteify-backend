FactoryBot.define do
  factory :patron do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { 'password' }
  end
end

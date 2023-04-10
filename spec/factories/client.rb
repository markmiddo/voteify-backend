FactoryBot.define do
  factory :client do
    sequence(:email) {|n| "client#{n}@example.com" }
    name { Faker::Name.name }
    password { 'password' }
    company_name { Faker::Company.name }
  end
end

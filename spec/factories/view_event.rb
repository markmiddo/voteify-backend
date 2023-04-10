FactoryBot.define do
  factory :view_event do
    association :patron, factory: :patron
    association :event, factory: :event_with_files
    page { %i[show_page vote_page].sample }
  end
end

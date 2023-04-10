# == Schema Information
#
# Table name: events
#
#  id                     :bigint(8)        not null, primary key
#  color                  :string
#  csv_file               :string
#  description            :text
#  end_date               :datetime
#  fb_pixel               :text
#  google_analytic        :text
#  landing_image          :string
#  min_user_count_to_vote :text
#  name                   :string
#  place                  :string
#  sharing_image          :string
#  start_date             :datetime
#  subtitle               :string
#  ticket_url             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  client_id              :bigint(8)
#
# Indexes
#
#  index_events_on_client_id  (client_id)
#
FactoryBot.define do
  factory :event do
    color {  %w[orange blue purple green pink].sample }
    text_color {  %w[white black].sample }
    name { Faker::Lorem.word }
    subtitle { Faker::Lorem.word }
    description { Faker::Lorem.paragraphs(number: 1) }
    start_date { Faker::Date.between(from: 2.days.from_now, to: 10.days.from_now) }
    end_date { start_date + 3.days }
    vote_end_date { start_date.instance_of?(Date) ? start_date + 2.days : 10.days.from_now }
    track_count_for_vote { 5 }
    place { Faker::Address.full_address }
    ticket_url { Faker::Internet.url(host: 'example.com') }
    client_id { FactoryBot.create(:client).id }
    facebook_title { Faker::Lorem.word }
    facebook_description { Faker::Lorem.word }
    share_title { Faker::Lorem.word }
    share_description { Faker::Lorem.word }
    shortlist_description { Faker::Lorem.word }
    top_songs_description { Faker::Lorem.word }
    event_url { Faker::Internet.url(host: 'example.com') }
    csv_processed_line_count { 0 }
    sequence(:sharing_count)

    trait :with_files do
      sharing_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      landing_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      square_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      csv_file { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/files/csv_example.csv')) }
      after(:create) {|event| event.load_tracks }
    end

    trait :skip_callback do
      after(:build) {|event| event.class.skip_callback(:commit, :after, :add_task_for_track_loading) }
      after(:create) {|event| event.class.set_callback(:commit, :after, :add_task_for_track_loading) }
    end

    trait :with_resources do
      sharing_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      landing_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      square_image { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }
      csv_file { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/files/csv_example.csv')) }
    end

    factory :event_with_files, traits: %i[with_files]
  end

end

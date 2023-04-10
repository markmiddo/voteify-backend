FactoryBot.define do
  factory :track do
    author   { Faker::Artist.name }
    title    { Faker::Job.title }
    video_id { Faker::Lorem.word }

    trait :with_local_resources do
      thumbnails { Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/support/images/test-img.jpg')) }

      after(:build) {|track| track.class.skip_callback(:save, :before, :load_youtube) }
      after(:create) {|track| track.class.set_callback(:save, :before, :load_youtube) }
    end
  end
end

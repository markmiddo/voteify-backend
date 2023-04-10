require "json"

def create_seeds
  puts 'create Admin user'
  admin = FactoryBot.build(:user, email: 'admin@example.com', password: 'password', password_confirmation: 'password', type: 'Admin')
  admin.save(:validate => false)
  puts 'create Patron'
  patrons = FactoryBot.create_list(:patron, 10, type: 'Patron', password: 'password', password_confirmation: 'password')

  puts 'create Client'
  clients = FactoryBot.create_list(:client, 10, type: 'Client', password: 'password', password_confirmation: 'password')

  puts 'create Event'
  clients.each do |client|
    FactoryBot.create_list(:event, 3, :skip_callback, :with_resources, client: client)
  end
  events = Event.all

  file = File.open File.join(File.dirname(__FILE__), "seeds/trackThumbnails.json")
  trackThumbnails = JSON.load file

  events.each do |event|
    track = FactoryBot.create_list(:track, 5, :with_local_resources, events: [event], thumbnails: trackThumbnails.sample)
  end


  puts 'create question'
  questions = FactoryBot.create_list(:question, 5)

  puts 'create_answers'
  questions.each do |question|
    patrons.each do |patron|
      FactoryBot.create(:answer, patron: patron, question: question)
    end
  end

  puts 'create_votes'
  events.each do |event|
    patrons.each do |patron|
      vote = FactoryBot.create(:vote, patron: patron, event: event)
      vote.make_sharing_images
    end
  end


  puts '========== Seeds created =============='
end

def remove_records_from_db
  puts '================== Clearing DB ===================='
  User.destroy_all
  Event.destroy_all
  Track.destroy_all
  Question.destroy_all
end

puts "Is you want to add db:seed? [Yes/No].\nWarning!!! This will delete all your data in the database"
answer = STDIN.gets.chomp
if answer == "Yes"
  remove_records_from_db
  create_seeds
end

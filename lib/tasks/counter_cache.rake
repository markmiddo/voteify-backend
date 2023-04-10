
task vote_counter: :environment do
  Event.reset_column_information
  Event.find_each do |p|
    Event.reset_counters p.id, :votes
  end
end

task event_track_vote_counter: :environment do
  EventTrack.reset_column_information
  EventTrack.find_each do |p|
    EventTrack.reset_counters p.id, :event_track_votes
  end
end

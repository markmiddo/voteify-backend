FactoryBot.define do
  factory :vote do
    association :patron, factory: :patron
    association :event, factory: :event_with_files
    event_track_votes_attributes do
      event.event_tracks.map.with_index do |track, index|
        { position: index + 1, event_track_id: track.id, is_top: true }
      end
    end
  end
end

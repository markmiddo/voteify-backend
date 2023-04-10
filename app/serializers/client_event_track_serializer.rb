# == Schema Information
#
# Table name: event_tracks
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint(8)
#  patron_id  :bigint(8)
#  track_id   :bigint(8)
#
# Indexes
#
#  index_event_tracks_on_event_id               (event_id)
#  index_event_tracks_on_event_id_and_track_id  (event_id,track_id) UNIQUE
#  index_event_tracks_on_patron_id              (patron_id)
#  index_event_tracks_on_track_id               (track_id)
#

class ClientEventTrackSerializer < EventTrackSerializer
  attributes :vote_count, :vote_points
end

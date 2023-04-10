# == Schema Information
#
# Table name: event_track_votes
#
#  id             :bigint(8)        not null, primary key
#  is_top         :boolean          default(FALSE), not null
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_track_id :bigint(8)
#  vote_id        :bigint(8)
#
# Indexes
#
#  index_event_track_votes_on_event_track_id  (event_track_id)
#  index_event_track_votes_on_vote_id         (vote_id)
#

class EventTrackVoteSerializer < ActiveModel::Serializer
  attributes :id, :position, :is_top

  has_one :event_track
end

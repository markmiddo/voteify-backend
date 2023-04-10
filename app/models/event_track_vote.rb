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

class EventTrackVote < ApplicationRecord

  belongs_to :event_track
  belongs_to :vote

  has_one :track, through: :event_track
  # counter_cache_with_conditions :event_track, :event_track_votes_count, is_top: true

  scope :only_top, -> { where(is_top: true) }

  after_create  :reset_counter_cache
  after_destroy :reset_counter_cache

  def reset_counter_cache
    event_track.reset_counter_cache
  end
end

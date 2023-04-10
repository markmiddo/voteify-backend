# == Schema Information
#
# Table name: event_tracks
#
#  id                      :bigint(8)        not null, primary key
#  event_track_votes_count :integer          default(0)
#  original_author         :string
#  original_title          :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  event_id                :bigint(8)
#  patron_id               :bigint(8)
#  track_id                :bigint(8)
#
# Indexes
#
#  index_event_tracks_on_event_id               (event_id)
#  index_event_tracks_on_event_id_and_track_id  (event_id,track_id) UNIQUE
#  index_event_tracks_on_patron_id              (patron_id)
#  index_event_tracks_on_track_id               (track_id)
#

class EventTrack < ApplicationRecord
  belongs_to :event
  belongs_to :track
  belongs_to :patron, optional: true
  has_many :event_track_votes, dependent: :destroy
  has_many :votes, through: :event_track_votes
  validates :track, uniqueness: { scope: :event }

  scope :order_by_track_name, -> { joins(:track).order('author', 'title') }

  delegate :track_name, to: :track, allow_nil: true

  def vote_count
    event_track_votes_count
  end

  def vote_points
    count = event.track_count_for_vote + 1
    query = "select sum(#{count} - position) from event_track_votes where event_track_id=#{id} and position > 0"
  
    (EventTrack.connection.execute(query).first['sum'] or 0) + duplication_points
  end

  def reset_counter_cache
    vote_count = event_track_votes.where(
                                    position: [1..event.track_count_for_vote]
                                  ).only_top.count

    self.update_columns(
      event_track_votes_count: vote_count
    )
  end
end

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

class EventTrackSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :track_id, :star
  belongs_to :track

  def star
    return false unless current_user.present?

    return current_user.id == object.try(:patron_id) if current_user.patron?

    object.try(:patron_id).nil?
  end
end

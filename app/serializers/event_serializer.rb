# == Schema Information
#
# Table name: events
#
#  id                       :bigint(8)        not null, primary key
#  color                    :string
#  csv_file                 :string
#  csv_processed_line_count :integer          default(0)
#  description              :text
#  end_date                 :datetime
#  event_url                :string
#  facebook_description     :string           not null
#  facebook_title           :string           not null
#  fb_pixel                 :string
#  google_analytic          :string
#  landing_image            :string
#  name                     :string
#  place                    :string
#  share_description        :string           not null
#  share_title              :string           not null
#  sharing_count            :integer          default(0)
#  sharing_image            :string
#  shortlist_description    :string
#  square_image             :string
#  start_date               :datetime
#  subtitle                 :string
#  text_color               :integer          default("white"), not null
#  ticket_url               :string
#  top_songs_description    :string           not null
#  track_count_for_vote     :integer
#  views_count              :integer          default(0)
#  vote_end_date            :datetime         not null
#  votes_count              :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  client_id                :bigint(8)
#
# Indexes
#
#  index_events_on_client_id  (client_id)
#

class EventSerializer < BaseEventSerializer
  attributes :ticket_url, :vote

  belongs_to :client, serializer: ClientPublicSerializer
  has_many :event_tracks do
    object.event_tracks.includes(:track).order_by_track_name
  end

  def ticket_url
     object.get_ticket_url(current_user)
  end

  def vote
    object.votes.where(patron: current_user).take
  end
end

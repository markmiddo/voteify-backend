# == Schema Information
#
# Table name: events
#
#  id                     :bigint(8)        not null, primary key
#  color                  :string
#  csv_file               :string
#  description            :text
#  end_date               :datetime
#  fb_pixel               :text
#  google_analytic        :text
#  landing_image          :string
#  min_user_count_to_vote :integer
#  name                   :string
#  place                  :string
#  sharing_image          :string
#  start_date             :datetime
#  subtitle               :string
#  ticket_url             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  client_id              :bigint(8)
#
# Indexes
#
#  index_events_on_client_id  (client_id)
#

class EventPublicSerializer < ActiveModel::Serializer
  attributes :id, :name, :subtitle, :start_date, :end_date, :place, :description, :ticket_url, :fb_pixel,
      :google_analytic, :landing_image, :color, :square_image, :top_songs_description, :track_count_for_vote,
             :shortlist_description, :facebook_title, :facebook_description, :vote_end_date

  belongs_to :client, serializer: ClientPublicSerializer

  has_many :event_tracks do
    object.event_tracks.includes(:track).order_by_track_name
  end
end

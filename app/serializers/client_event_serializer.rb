# == Schema Information
#
# Table name: events
#
#  id                   :bigint(8)        not null, primary key
#  color                :string
#  csv_file             :string
#  description          :text
#  end_date             :datetime
#  fb_pixel             :text
#  google_analytic      :text
#  landing_image        :string
#  name                 :string
#  place                :string
#  sharing_image        :string
#  start_date           :datetime
#  subtitle             :string
#  ticket_url           :string
#  track_count_for_vote :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  client_id            :bigint(8)
#
# Indexes
#
#  index_events_on_client_id  (client_id)
#

class ClientEventSerializer < ActiveModel::Serializer
  has_many :votes, serializer: ClientVoteSerializer
  has_many :event_tracks, serializer: ClientEventTrackSerializer

  attributes :id, :name, :subtitle, :start_date, :end_date, :place, :description, :ticket_url, :fb_pixel,
             :google_analytic, :track_count_for_vote, :landing_image, :sharing_image, :color, :votes_count,
             :votes_shared_count, :event_show_page_visit_count, :event_vote_page_visit_count, :sharing_count,
             :views_count, :csv_file

  def votes_shared_count
    object.votes.shared.size
  end

  def event_show_page_visit_count
    object.view_events.show_page.size
  end

  def event_vote_page_visit_count
    object.view_events.vote_page.size
  end
end

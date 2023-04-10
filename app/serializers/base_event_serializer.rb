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

class BaseEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :subtitle, :start_date, :end_date, :place, :description, :fb_pixel, :google_analytic,
             :track_count_for_vote, :landing_image, :sharing_image, :square_image, :color, :csv_file, :ticket_url,
             :facebook_title, :facebook_description, :share_title, :share_description, :text_color,
             :top_songs_description, :shortlist_description, :current_user_id, :vote_end_date


  def current_user_id
    if current_user.present?
      current_user.id
    end
  end
end

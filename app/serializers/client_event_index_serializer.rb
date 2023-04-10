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

class ClientEventIndexSerializer < ActiveModel::Serializer

  attributes :id, :name, :start_date, :end_date, :landing_image, :place, :votes_count, :sharing_count,
             :views_count
end

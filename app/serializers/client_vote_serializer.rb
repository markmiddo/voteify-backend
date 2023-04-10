# == Schema Information
#
# Table name: votes
#
#  id            :bigint(8)        not null, primary key
#  sharing_image :string
#  status        :integer          default("not_shared")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  event_id      :bigint(8)
#  patron_id     :bigint(8)
#
# Indexes
#
#  index_votes_on_created_at  (created_at)
#  index_votes_on_event_id    (event_id)
#  index_votes_on_patron_id   (patron_id)
#  index_votes_on_status      (status)
#

class ClientVoteSerializer < ActiveModel::Serializer
  attributes :id, :status, :updated_at, :sharing_image

  has_one :patron
end

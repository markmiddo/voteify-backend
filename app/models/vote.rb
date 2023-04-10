# == Schema Information
#
# Table name: votes
#
#  id                   :bigint(8)        not null, primary key
#  sharing_image        :string
#  square_sharing_image :string
#  status               :integer          default("not_shared")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  event_id             :bigint(8)
#  patron_id            :bigint(8)
#
# Indexes
#
#  index_votes_on_created_at              (created_at)
#  index_votes_on_event_id                (event_id)
#  index_votes_on_event_id_and_patron_id  (event_id,patron_id) UNIQUE
#  index_votes_on_patron_id               (patron_id)
#  index_votes_on_status                  (status)
#

class Vote < ApplicationRecord
  belongs_to :patron
  belongs_to :event, counter_cache: true
  has_many :event_track_votes, dependent: :destroy

  counter_cache_with_conditions :event, :sharing_count, status: 'shared'

  mount_uploader :sharing_image, SharingImageUploader
  mount_uploader :square_sharing_image, ImageUploader

  accepts_nested_attributes_for :event_track_votes
  enum status: %i[not_shared shared]

  validates :patron_id, uniqueness: { scope: :event_id, message: :not_unique_vote }, on: :create
  validate :validate_vote_end_date, on: :create

  def validate_vote_end_date
    if event.vote_end_date.try(:past?)
      errors.add :vote_is_over, I18n.t('activerecord.errors.models.vote.logic.vote_is_over')
    end
  end

  def make_sharing_images
    sharing_image = self.event.sharing_image
    square_image = self.event.square_image
    text_color = self.event.text_color
    event_track_list = self.event_track_votes.only_top.includes(:track).order('position asc')
    self.sharing_image = WideSharingImageDrawer.new(sharing_image, text_color, event_track_list).make_image
    self.square_sharing_image = SquareSharingImageDrawer.new(square_image, text_color, event_track_list).make_image
    self.save

    self
  end
end

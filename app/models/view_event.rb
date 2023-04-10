# == Schema Information
#
# Table name: view_events
#
#  id          :bigint(8)        not null, primary key
#  page        :integer
#  visitor_uid :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint(8)
#  patron_id   :bigint(8)
#
# Indexes
#
#  index_view_events_on_event_id   (event_id)
#  index_view_events_on_patron_id  (patron_id)
#  view_events_index               (patron_id,event_id,visitor_uid,page) UNIQUE
#

class ViewEvent < ApplicationRecord

  belongs_to :event, counter_cache: :views_count
  belongs_to :patron, optional: true

  validates :page, presence: true
  validate :unique_visit

  enum page: %i[show_page vote_page]

  private

  def unique_visit
    if ViewEvent.where(event_id: event_id, patron_id: patron_id, visitor_uid: visitor_uid, page: page).present?
      errors.add :unique_visit, 'you visit this page before'
    end
  end

end

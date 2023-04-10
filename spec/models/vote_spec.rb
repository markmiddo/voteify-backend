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

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'sharing image in vote' do
    let(:sharing_image_width) { 600 }
    let(:sharing_image_height) { 315 }
    let(:event) { create(:event, :with_resources) }
    let!(:vote) { create(:vote, event: event) }

    it 'create sharing image with correct size' do
      vote.make_sharing_images

      expect(vote.sharing_image.width).to eq sharing_image_width
      expect(vote.sharing_image.height).to eq sharing_image_height
    end
  end

  describe 'track name with quotes inside tracks title' do
    let(:event) { create(:event, :with_resources) }
    let(:track) { create(:track, title: "Avicii - Enough Is Enough (Don't Give Up On Us)") }
    let!(:event_track) { create(:event_track, event: event, track: track) }
    let!(:vote) { create(:vote, event: event) }


    it 'create images with quotes inside track names' do
      vote.make_sharing_images

      expect(vote.sharing_image).to be
      expect(vote.sharing_image.height).to be
    end
  end
end

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

require 'rails_helper'

RSpec.describe EventTrack, type: :model do

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  let(:event) { create(:event, :with_files) }
  let(:votes) { create_list(:vote, 5, event: event) }
  subject { votes }

  describe 'calculating statistic' do

    it 'should return correct vote_count' do
      subject
      event_tracks = EventTrack.all
      event_tracks.each do |event_track|
        expect(event_track.vote_count).to eq(EventTrackVote.where(event_track_id: event_track.id).count)
      end
    end

    it 'should vote_points present' do
      subject
      event_tracks = EventTrack.all
      event_tracks.each do |event_track|
        expect(event_track.vote_points).not_to be_nil
      end
    end
  end

  describe '.merge!' do
    it 'it should merge and calculating statistic properly' do
      subject

      merged_event_tracks  = event.event_tracks.reload
      greatest_id          = merged_event_tracks.map(&:id).max
      remained_event_track = merged_event_tracks.find(greatest_id)
      new_vote_count       = merged_event_tracks.map(&:vote_count).sum
      new_vote_points      = merged_event_tracks.map(&:vote_points).sum

      event.merge_event_tracks!(merged_event_tracks.ids)

      expect(event.event_tracks.count).to    be(1)
      expect(event.event_tracks.last.id).to  be(greatest_id)

      remained_event_track = EventTrack.find(greatest_id)

      expect(remained_event_track.event_track_votes_count).to  eq(new_vote_count)
      expect(remained_event_track.vote_points).to eq(new_vote_points)
    end
  end

  after(:all) do
    FileUtils.rm_rf('public/uploads/test/.')
    FileUtils.rm_rf('public/uploads/tmp/.')
  end
end

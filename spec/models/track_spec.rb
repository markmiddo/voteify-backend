# == Schema Information
#
# Table name: tracks
#
#  id                  :bigint(8)        not null, primary key
#  author              :string
#  published_at        :datetime
#  thumbnails          :string
#  title               :string
#  youtube_description :text
#  youtube_title       :string
#  video_id            :string
#
# Indexes
#
#  index_tracks_on_author    (author)
#  index_tracks_on_title     (title)
#  index_tracks_on_video_id  (video_id)
#

require 'rails_helper'

RSpec.describe Track, type: :model do

  before(:each) do
    allow(YouTube).to receive(:http_get).and_return YouTubeSuccess.new
  end

  describe '#create' do

    subject { create :track, title: 'The best' , author: 'Дима Билан', video_id: nil }

    it 'create success' do
      expect {
        subject
      }.to change(Track, :count).by 1
    end

    it 'filled fields' do
      expect(subject.title).to eq 'The best'
      expect(subject.author).to eq 'Дима Билан'
      expect(subject.video_id).to_not be_empty
      expect(subject.thumbnails).to_not be_empty
      expect(subject.youtube_title).to_not be_empty
      expect(subject.youtube_description).to_not be_empty
    end
  end

  describe 'strip whitespaces before validation' do
    let(:track_title) { "title\r\n" }
    let(:track_author) { "author\r\n" }
    let(:track) { build(:track, author: track_author, title: track_title) }

    it 'strip whitespaces inside track title' do
      track.valid?
      expect(track.title).to eq track_title.strip
    end

    it 'strip whitespaces inside track author' do
      track.valid?
      expect(track.author).to eq track_author.strip
    end
  end
end

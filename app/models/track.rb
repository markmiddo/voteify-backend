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

class Track < ApplicationRecord
  serialize :thumbnails, Hash

  has_many :event_tracks,dependent: :destroy
  has_many :events, through: :event_tracks

  validates :title, :author, presence: true

  before_validation :trim_whitespaces
  before_save :load_youtube, if: -> { video_id.nil? }

  class << self

    def load_track(author, title)
      track = find_track(author, title)

      if track.nil?
        response = YouTube.search("#{author} #{title}")

        if response.present? && response.dig('id', 'videoId').present?
          track = find_by(video_id: response['id']['videoId'])
          track = create_track(response, author, title) if track.nil?
        end
      end

      track
    end

    private

    def create_track(response, author, title)
      create author:              author,
             title:               title,
             video_id:            response['id']['videoId'],
             thumbnails:          response['snippet']['thumbnails'],
             youtube_title:       response['snippet']['title'],
             youtube_description: response['snippet']['description'],
             published_at:        response['snippet']['publishedAt']
    end

    def find_track(author, title)
      where('lower(author) = :author and lower(title) = :title',
             { author: author.downcase, title: title.downcase }).take
    end
  end

  def track_name
    "#{author} - #{title}"
  end
  private

  def load_youtube
    response = YouTube.search("#{author} #{title}")

    self.video_id = response['id']['videoId']
    self.thumbnails = response['snippet']['thumbnails']
    self.youtube_title = response['snippet']['title']
    self.youtube_description = response['snippet']['description']
    self.published_at = response['snippet']['publishedAt']
  end

  def trim_whitespaces
    self.author = self.author.strip if self.author.present?
    self.title = self.title.strip if self.title.present?
  end
end

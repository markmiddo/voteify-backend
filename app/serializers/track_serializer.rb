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

class TrackSerializer < ActiveModel::Serializer
  attributes :id, :author, :title, :published_at, :thumbnails, :youtube_description, :youtube_title, :video_id
end

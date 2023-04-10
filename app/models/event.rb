# == Schema Information
#
# Table name: events
#
#  id                       :bigint(8)        not null, primary key
#  color                    :string
#  csv_file                 :string
#  csv_processed_line_count :integer          default(0)
#  description              :text
#  end_date                 :datetime
#  event_url                :string
#  facebook_description     :string           not null
#  facebook_title           :string           not null
#  fb_pixel                 :string
#  google_analytic          :string
#  landing_image            :string
#  name                     :string
#  place                    :string
#  share_description        :string           not null
#  share_title              :string           not null
#  sharing_count            :integer          default(0)
#  sharing_image            :string
#  shortlist_description    :string
#  square_image             :string
#  start_date               :datetime
#  subtitle                 :string
#  text_color               :integer          default("white"), not null
#  ticket_url               :string
#  top_songs_description    :string           not null
#  track_count_for_vote     :integer
#  views_count              :integer          default(0)
#  vote_end_date            :datetime         not null
#  votes_count              :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  client_id                :bigint(8)
#
# Indexes
#
#  index_events_on_client_id  (client_id)
#

require 'csv'
require 'open-uri'

class Event < ApplicationRecord
  belongs_to :client
  has_many :event_tracks, dependent: :destroy
  has_many :tracks, through: :event_tracks
  has_many :view_events, dependent: :destroy
  has_many :votes, dependent: :destroy

  after_commit :after_commit_copy_track_from_event, if: :persisted?

  validate :validate_start_date, if: -> { start_date.present? }
  validate :validate_end_date, if: -> { end_date.present? }

  validates_presence_of :name, :subtitle, :start_date, :end_date, :ticket_url, :track_count_for_vote, :place, :csv_file,
                        :landing_image, :sharing_image, :square_image, :facebook_title, :facebook_description,
                        :share_title, :share_description, :top_songs_description, :text_color, :vote_end_date

  validates :track_count_for_vote, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :square_image, presence: true, square_image: true, if: Proc.new {|vote| vote.square_image.present? }
  validates :fb_pixel,
            format:      { with: /\A\d{5,}\z/, message: I18n.t('activerecord.errors.models.event.attributes.fb_pixel.format') },
            allow_blank: true
  validates :google_analytic,
            format:
                         { with:    /\A(UA|YT|MO)-\d{4,9}-\d{1,4}\z/,
                           message: I18n.t('activerecord.errors.models.event.attributes.google_analytic.format') },
            allow_blank: true

  enum text_color: %i[white black]
  mount_uploader :sharing_image, SharingImageUploader
  mount_uploader :square_image, ImageUploader
  mount_uploader :landing_image, LandingImageUploader
  mount_uploader :csv_file, FileUploader

  before_validation :trim_whitespaces
  after_commit :add_task_for_track_loading, on: :create

  scope :active_event, -> { where('start_date >= ?', Date.today) }

  scope :day, ->(params) { period(Date.today, Date.today) }
  scope :week, ->(params) { period(1.week.ago, Date.today) }
  scope :month, ->(params) { period(1.month.ago, Date.today) }
  scope :specified_period, ->(params) {
    period(safe_parse(params[:from]), safe_parse(params[:to]))
  }

  scope :period, -> (from, to) { where(start_date: from..to) }

  scope :filters, -> (params) {
    events = all
    events = events.filter_by_date(params) if params[:date_filter].present?
    events = events.filter_by_order(params) if params[:order].present?
    events
  }

  attr_reader :copy_track_from_event

  def copy_track_from_event=(val)
    return val if val == copy_track_from_event
    @copy_track_from_event = val
    self.updated_at = Time.zone.now
  end


  def self.filter_by_order(params)
    order_name = params[:order].try(:to_sym)
    return order(end_date: :desc) if order_name == :end_date
    return order(start_date: :desc) if order_name == :start_date
    return order(name: :asc) if order_name == :name
    return order(views_count: :desc) if order_name == :views
    return order(sharing_count: :desc) if order_name == :sharing
  end

  def self.filter_by_date(params)
    filter_name = params[:date_filter].try(:to_sym)
    %i[day week month specified_period].include?(filter_name) ? send(filter_name, params) : all
  end

  def get_ticket_url(user)
    votes.shared.where(patron_id: user.id).present? ? ticket_url : nil
  end

  def load_tracks
    file = get_file_object

    CSV.read(file, 'r:bom|utf-8').drop(csv_processed_line_count).each do |(author, title)|
      if author.present? && title.present?
        author = author.strip
        title = title.strip
        logger = Logger.new("#{Rails.root}/log/track_name.log")
        logger.debug "Track: #{author} - #{title}"
        track = Track.load_track(author, title)

        event_tracks.create(track: track, original_title: title, original_author: author)

        update(csv_processed_line_count: csv_processed_line_count + 1)
      end
    end
  end

  def votes_by_user(vote_owner)
    votes.where(patron: vote_owner)
  end

  def merge_event_tracks!(ids)
    greatest_id          = ids.max.to_i
    merged_event_tracks  = event_tracks.where(id: ids)
    remained_event_track = merged_event_tracks.find(greatest_id)

    merged_event_tracks.each do |event_track|
      if event_track.id != greatest_id
        event_track.event_track_votes.update_all(event_track_id: remained_event_track.id)
        event_track.destroy
      end
    end

    remained_event_track.reset_counter_cache
  end

  private

  def validate_start_date
    if start_date < Date.today
      errors.add :start_date, 'Start date cannot be earlier than current date.'
    end
  end

  def get_file_object
    File.new(csv_file.path, 'r')
  end

  def validate_end_date
    if end_date < start_date
      errors.add :end_date, 'End date cannot be earlier than start date.'
    end
  end

  def self.safe_parse(value)
    Date.parse(value.to_s)
  rescue ArgumentError
    Date.today
  end

  def add_task_for_track_loading
    TrackLoaderJob.perform_later(id)
  end

  def trim_whitespaces
    self.fb_pixel = self.fb_pixel.strip if self.fb_pixel.present?
    self.google_analytic = self.google_analytic.strip if self.google_analytic.present?
  end

  private
  def after_commit_copy_track_from_event
    if (self.copy_track_from_event != nil && self.copy_track_from_event.empty? == false)
      query = "INSERT INTO event_tracks(event_id, track_id, created_at, updated_at)
      SELECT '#{self.id}' as event_id, track_id, now(), now() FROM event_tracks where event_id='#{self.copy_track_from_event}' ON CONFLICT DO NOTHING;"
      EventTrack.connection.execute(query)
    end
  end
end

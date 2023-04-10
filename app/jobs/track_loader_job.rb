class TrackLoaderJob < ApplicationJob
  queue_as :default

  retry_on BadRequestError, wait: 24.hours, queue: :default

  def perform(event_id)
    event = Event.find_by(id: event_id.to_i)
    event.try(:load_tracks)
  end
end

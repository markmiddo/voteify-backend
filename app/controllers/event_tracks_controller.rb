class EventTracksController < ApiController
  before_action :authenticate_user, except: [:create]

  expose :event_track

  def create
    authorize new_event_track
    new_event_track.save
    render_resource_or_errors new_event_track
  end

  def destroy
    authorize event_track
    event_track.destroy
    render_resource_or_errors event_track
  end

  private

  def new_event_track
    @new_event_track ||= EventTrack.new event: event, track: track, patron_id: current_user.try(:id)
  end

  def event
    @event ||= Event.find(params[:resource][:event_id])
  end

  def track
    @track ||= Track.load_track(params[:resource][:author], params[:resource][:title])
  end
end

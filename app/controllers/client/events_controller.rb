class Client::EventsController < ApiController

  before_action :authenticate_user

  expose :new_event, model: Event
  expose :event
  expose :events, -> { current_user.events.filters(params) }

  def index
    render_resources(events, each_serializer: ClientEventIndexSerializer)
  end

  def show
    authorize event, :can_client_show?
    event = Event.includes(votes: :patron, event_tracks: :track).find(params[:id])
    render_resource(event, serializer: ClientEventSerializer)
  end

  def create
    authorize new_event
    new_event.save
    render_resource_or_errors(new_event,serializer: ClientEventSerializer)
  end

  def update
    authorize(event)
    event.update(permitted_attributes(event))
    render_resource_or_errors(event, serializer: ClientEventSerializer)
  end

  def destroy
    authorize(event)
    event.destroy
    render_resource_or_errors(event, serializer: ClientEventSerializer)
  end

  private

  def new_event_params
    permitted_attributes(Event.new).merge(
        client:   current_user
    )
  end

end

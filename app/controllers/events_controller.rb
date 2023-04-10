class EventsController < ApiController

  expose :event
  expose :events, -> { Event.active_event.filters(params)  }

  before_action :skip_authorization, only: %i[show]
  before_action :authenticate_user, except: %i[show]

  def index
    render_resources(events)
  end

  def show
    render_resource(event, serializer: show_page_serializer)
  end

  private

  def new_event_params
    permitted_attributes(Event.new).merge(
        client:   current_user
    )
  end

  def show_page_serializer
    current_user.present? ? EventSerializer  : EventPublicSerializer
  end

end

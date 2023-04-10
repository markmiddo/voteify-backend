class ViewEventsController < ApiController

  def create
    ViewEvent.create(new_view_event_params)
    render :ok
  end

  def new_view_event_params
    permitted_attributes(ViewEvent.new)
  end
end

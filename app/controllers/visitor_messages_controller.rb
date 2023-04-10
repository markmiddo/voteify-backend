class VisitorMessagesController < ApiController

  before_action :skip_authorization

  def create
    visitor_message = VisitorMessage.create(visitor_message_params)
    render_resource_or_errors(visitor_message)
  end

  private

  def visitor_message_params
    permitted_attributes(VisitorMessage.new)
  end
end

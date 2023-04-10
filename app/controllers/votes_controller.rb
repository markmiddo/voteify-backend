class VotesController < ApiController

  expose :vote

  before_action :skip_authorization

  def show
    render_resource_or_errors(vote, serializer: PublicVoteSerializer)
  end
end


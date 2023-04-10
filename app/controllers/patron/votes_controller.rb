class Patron::VotesController < ApiController

  before_action :authenticate_user
  before_action :authorize_patron, only: %i[create update]

  expose :vote
  expose :votes, -> { current_user.votes.includes(:event, event_track_votes: [event_track: :track]) }
  expose :event, id: :event_id, Model: Event

  def index
    render_resources(votes)
  end

  def create
    authorize event, :can_vote?
    new_vote = event.votes.create(new_vote_params)
    new_vote.make_sharing_images
    render_resource_or_errors(new_vote)
  end

  def update
    authorize(vote)
    vote.event_track_votes.destroy_all if event_track_votes_present?
    vote.update(permitted_attributes(vote))
    vote.make_sharing_images  if event_track_votes_present?
    render_resource_or_errors(vote)
  end

  def show
    render_resource_or_errors(vote)
  end

  def new_vote_params
    permitted_attributes(Vote).merge(
        patron: current_user
    )
  end

  private

  def event_track_votes_present?
    permitted_attributes(vote).include? :event_track_votes_attributes
  end
end


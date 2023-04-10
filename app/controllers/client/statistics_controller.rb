class Client::StatisticsController < ApiController
  before_action :authenticate_user

  def index
    statistic = VoteStatistic.new(current_user)
    authorize statistic
    render json: statistic.all
  end
end

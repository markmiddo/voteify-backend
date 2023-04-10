class VoteStatisticPolicy < ApplicationPolicy

  def index?
    user.client?
  end

end

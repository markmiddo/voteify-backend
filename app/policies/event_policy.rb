class EventPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    user.blank? || user.patron?
  end

  def create?
    user.client?
  end

  def update?
    record.client_id == user.id
  end

  def destroy?
    record.client_id == user.id
  end

  def can_vote?
    !record.votes_by_user(user).exists?
  end

  def can_client_show?
    user.id == record.client_id
  end

  def permitted_attributes
    %i(name subtitle start_date end_date place description ticket_url fb_pixel google_analytic track_count_for_vote
    color landing_image square_image sharing_image csv_file text_color top_songs_description share_description
    share_title event_url facebook_description  facebook_title shortlist_description)
  end
end

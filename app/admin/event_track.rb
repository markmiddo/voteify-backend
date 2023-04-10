ActiveAdmin.register EventTrack do
  belongs_to :event
  permit_params :event_id, :track_id, :patron_id, :duplication_points

  controller do
    def scoped_collection
      self.action_name == 'index' ? (super.includes :track, :patron) : super
    end

    def apply_sorting(chain)
      # add + 1 to result, in order to vote with 1 position get 1 votes point
      # add + 1 for track with 0 position in order to such track has not votes points
      super
          .left_outer_joins(:track, :patron, :event, :event_track_votes)
          .select(
              'event_tracks.*',
              '(sum(events.track_count_for_vote - COALESCE(NULLIF(event_track_votes.position, 0),
                events.track_count_for_vote + 1) + 1) + event_tracks.duplication_points) as vote_points_value',
              'event_track_votes_count as vote_count_value',
              'max(tracks.author)||max(tracks.title) as track_name',
              'max(users.name) as patron_name'
          )
          .group('event_tracks.id')
    end
  end

  index do
    selectable_column
    id_column

    column(:track, sortable: 'track_name') { |event_track|
      link_to(event_track.track_name, edit_admin_track_path(
        event_track.track, event_id: params[:event_id])
      )
    }
    column(:patron, sortable: 'patron_name') {|event_track| event_track.patron.name if event_track.patron.present? }
    column(:vote_count, sortable: 'vote_count_value') {|event_track| event_track.vote_count_value }
    column(:vote_points, sortable: 'vote_points_value') {|event_track| event_track.vote_points_value }
    column(:duplication_points, sortable: 'duplication_points') {|event_track| event_track.duplication_points }
    actions
  end

  csv do
    column :id
    column(:track_name) {|event_track| event_track.track.track_name }
    column(:patron) {|event_track| event_track.patron.name if event_track.patron.present? }
    column(:vote_count) {|event_track| event_track.vote_count }
    column(:vote_points) {|event_track| event_track.vote_points }
    column(:duplication_points) {|event_track| event_track.duplication_points }
  end

  filter :track_author, as: :string, label: 'Author'
  filter :track_title, as: :string, label: 'Title'
  filter :patron
  filter :created_at

  collection_action :destroy_event_tracks, method: :post, confirm: true do
    response_msg = {}
    begin
      if params[:event_tracks].present?
        destroyed_events = EventTrack.includes(:event_track_votes).where(id: params[:event_tracks]).destroy_all
        response_msg[:notice] = I18n.t('active_admin.success.records_destroyed', count: destroyed_events.length)
      else
        response_msg[:notice] = I18n.t('active_admin.errors.elements_not_selected')
      end
    rescue StandardError => e
      response_msg[:notice] = e.message
    end

    redirect_to admin_event_path(id: params[:event_id]), response_msg
  end

  batch_action :merge do |ids|
     Event.find(params[:event_id]).merge_event_tracks!(ids)

     redirect_to(admin_event_event_tracks_path(id: params[:event_id]),
       alert: "The event tracks have been merged."
     )
  end
end

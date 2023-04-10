ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      render 'scope_component', scope_values: build_scope_data_for_view, selected_value: take_vote_range_from_params
    end
    columns do
      column do
        votes_statistic = Event.joins(:votes)
                              .where(build_vote_range_restriction(take_vote_range_from_params))
                              .select([
                                          'count(votes.*) votes_count',
                                          'min(votes.created_at) min_vote_date',
                                          'max(votes.created_at) max_vote_date',
                                          'min(events.name) as event_name',
                                          'max(events.place) as event_location',
                                          'events.id'])
                              .group('events.id')

        panel 'Events statistic', class: 'statistic_panel' do
          paginated_collection(votes_statistic.page(params[:page]).per(15), param_name: :page, download_links: false) do
            table_for collection, sortable: false do
              column(:event) {|statistic| link_to statistic.event_name, admin_event_path(statistic.id) }
              column(:dates) {|statistic| "#{statistic.min_vote_date.to_date} - #{statistic.max_vote_date.to_date}" }
              column(:votes_count) {|statistic| statistic.votes_count }
              column(:location) {|statistic| statistic.event_location }
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent Client' do
          table_for Client.order('id desc').limit(10) do
            column(:email) {|c| link_to(c.email, admin_client_path(c)) }
            column :name
            column :company_name
          end
          text_node link_to 'More client', admin_clients_path
        end
      end
      column do
        panel 'Recent patrons' do
          table_for Patron.order('id desc').limit(10) do
            column(:email) {|p| link_to(p.email, admin_patron_path(p)) }
            column :name
          end
          text_node link_to 'More patrons', admin_patrons_path
        end
      end
    end

    columns do
      column do
        panel 'Recent tracks' do
          table_for EventTrack.includes(:track, :event).order('id desc').limit(10) do
            column(:track_title) {|event_track| event_track.track.track_name }
            column :vote_count
            column(:vote_points) {|event_track| event_track.vote_points }
          end
        end
      end
    end
  end

  controller do
    helper_method :build_vote_range_restriction, :scope_values, :build_scope_data_for_view, :take_vote_range_from_params

    def scope_values
      %i[day week month total]
    end

    def default_vote_range
      :week
    end

    def build_scope_data_for_view
      scope_values.map do |value|
        { link: admin_dashboard_path(scope: value), value: value }
      end
    end

    def build_vote_range_restriction(range)
      ranges_restrictions = {
          day:   { 'votes.created_at': Date.today.beginning_of_day..Date.today.end_of_day },
          week:  { 'votes.created_at': 1.week.ago.beginning_of_day..Date.today.end_of_day },
          month: { 'votes.created_at': 1.month.ago.beginning_of_day..Date.today.end_of_day },
          total: {}
      }

      ranges_restrictions.key?(range) ? ranges_restrictions[range] : ranges_restrictions[default_scope]
    end

    def take_vote_range_from_params
      params[:scope].try(:to_sym) || default_vote_range
    end
  end
end

ActiveAdmin.register Event do
  permit_params :name, :subtitle, :start_date, :end_date, :place, :description, :ticket_url, :fb_pixel, :google_analytic,
                :track_count_for_vote, :color, :landing_image, :sharing_image, :square_image, :csv_file, :client_id,
                :top_songs_description, :event_url, :facebook_title, :facebook_description, :share_title,
                :share_description, :text_color, :square_image, :shortlist_description, :vote_end_date, :copy_track_from_event

  index do
    selectable_column
    id_column
    column :name
    column :start_date
    column :end_date
    column :vote_end_date
    column :place
    column :created_at
    column(:tracks) {|event| link_to('Tracks', admin_event_event_tracks_path(event)) }
    column(:votes) {|event| link_to('Votes', admin_event_votes_path(event)) }
    column(:event_url) {|event| link_to event.event_url, event.event_url }
    actions
  end

  show do
    attributes_table do
      row(:client) {|event| link_to event.client.email, admin_client_path(event.client) if event.client }
      rows :name, :subtitle, :start_date, :end_date, :vote_end_date, :place, :shortlist_description, :description,
           :fb_pixel, :google_analytic, :track_count_for_vote, :facebook_title, :facebook_description, :share_title,
           :share_description, :text_color
      row(:landing_image) {|event| link_to(image_tag(event.landing_image.versions[:small].url), event.landing_image.url) }
      row(:sharing_image) {|event| link_to(image_tag(event.sharing_image.url, width: 128, height: 128), event.sharing_image.url) }
      row(:square_image) {|event| link_to(image_tag(event.square_image.url, width: 128, height: 128), event.square_image.url) }
      row('redirect URL') {|event| event.ticket_url }
    end
    panel 'Tracks' do
      form_properties = { action: destroy_event_tracks_admin_event_event_tracks_path(event), method: :post }
      form form_properties do |f|
        column_number = 0
        table_for event.event_tracks.includes(:track) do
          column(input type: :checkbox, class: :toggle_all_inside_table_body) do |event_track|
            f.input :id, type: :checkbox, name: 'event_tracks[]', value: event_track.id
          end
          column(:track_number) { column_number+=1 }
          column(:track) {|event_track| link_to event_track.track.track_name,
                                                admin_event_event_track_path(id:       event_track.id,
                                                                             event_id: event_track.event_id)  }
          column(:track_votes_count) {|event_track| event_track.vote_count }
          column(:track_votes_point) {|event_track| event_track.vote_points }
          column(:duplication_points) {|event_track| event_track.duplication_points }
        end
        f.input name: 'authenticity_token', type: :hidden, value: form_authenticity_token.to_s
        f.input type: :submit, value: I18n.t('active_admin.delete')
      end
    end
  end

  form do |f|
    unless f.object.persisted? then
      f.object.share_title = I18n.t('active_admin.default_input_values.share_title')
      f.object.share_description = I18n.t('active_admin.default_input_values.share_description')
      f.object.top_songs_description = I18n.t('active_admin.default_input_values.top_songs_description')
    end

    f.inputs do
      f.input :client_id, label: 'Client', as: :select, collection: Client.all.map {|u| ["#{u.name} #{u.email}", u.id] }
      f.input :name
      f.input :subtitle
      f.input :start_date
      f.input :end_date
      f.input :vote_end_date, as: :datetime_select
      f.input :place
      f.input :shortlist_description
      f.input :description
      f.input :top_songs_description
      f.input :event_url
      f.input :ticket_url, label: 're-direct URL'
      f.input :facebook_title
      f.input :facebook_description
      f.input :fb_pixel, label: 'FB PIXEL ID', hint: I18n.t('active_admin.hints.fb_pixel')
      f.input :google_analytic, label: 'GOOGLE ANALYTIC ID', hint: I18n.t('active_admin.hints.google_analytic')
      f.input :share_title
      f.input :share_description
      f.input :track_count_for_vote, as: :select, collection: (1..10).to_a
      f.input :color, as: :select, collection: %i(purple orange green blue pink)
      f.input :text_color, as: :select, collection: %i(white black)
      f.input :landing_image
      f.input :sharing_image
      f.input :square_image
      f.input :csv_file, hint: link_to('Template', '/uploads/templates/event_tracks_template.csv')
      f.input :copy_track_from_event, label: 'Copy Tracks From Event', as: :select, collection: Event.all.select('events.id, events.name').order(id: :desc).map {|u| ["#{u.id} - #{u.name}", u.id] }
    end
    f.actions
  end

  csv do
    column :id
    column :name
    column :subtitle
    column :start_date
    column :end_date
    column :place
    column :description
    column :shortlist_description
    column :ticket_url
    column :fb_pixel
    column :google_analytic
    column :track_count_for_vote
    column :color
    column :created_at
    column :updated_at
  end

  filter :client
  filter :tracks
  filter :name
  filter :subtitle
  filter :start_date
  filter :end_date
  filter :place
  filter :ticket_url
end


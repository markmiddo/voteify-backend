ActiveAdmin.register Track do
  permit_params :title, :author

  actions :index, :show, :edit, :update, :destroy

  filter :title
  filter :author
  filter :events, label: 'Event'

  controller do
    def update
      super do |success|
        if params[:event_id].present?
          success.html {
            redirect_to admin_event_event_tracks_path(params[:event_id])
          }
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :author
    column(:youtube) {|track| image_tag track.thumbnails['default']['url'] }
    column :youtube_title
    actions
  end

  show do
    attributes_table do
      rows :title, :author, :youtube_title, :video_id, :youtube_description, :created_at
      row(:thumbnails) {|track| link_to(image_tag(track.thumbnails['default']['url']), track.thumbnails['high']['url']) }
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :author

      li hidden_field_tag :event_id, params[:event_id]
    end
    f.actions
  end

  csv do
    column :id
    column :title
    column :author
    column(:video) {|track| track.video_id }
    column :youtube_title
    column :youtube_description
    column :published_at
  end
end

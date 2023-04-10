ActiveAdmin.register Vote do
  actions :index, :show

  belongs_to :event, optional: true

  scope :all, default: true
  scope :not_shared
  scope :shared

  controller do
    def scoped_collection
      return super.includes :patron if self.params.key?(:event_id)
      return super.includes :patron, :event if self.action_name == 'index'
      return super
    end
  end

  index do
    selectable_column
    id_column
    column(:patron_name) {|vote| link_to vote.patron.name, admin_patron_path(vote.patron) }
    column(:patron_email) {|vote| link_to vote.patron.email, admin_patron_path(vote.patron) }
    column(:event) {|vote| link_to vote.event.name, admin_event_path(vote.event) }
    column :created_at
    column(:status) {|vote| status_tag vote.status }
    column(:sharing_image) do |vote|
      if vote.sharing_image.present?
        link_to(image_tag(vote.sharing_image.url, width: 128, height: 128), vote.sharing_image.url)
      end
    end
    actions
  end


  show do
    attributes_table do
      rows :patron, :event, :created_at, :status
      row(:sharing_image) {|vote| image_tag vote.sharing_image.url }
      row(:sharing_square_image) {|vote| image_tag vote.square_sharing_image.url }
    end
    panel 'Track votes' do
      table_for vote.event_track_votes.includes(:event_track, event_track: :track) do
        column(:track) {|vote| vote.event_track.track.track_name }
        column :position
      end
    end
  end

  filter :patron, collection: proc { Patron.all.map{|p| [[p.name, p.email].join(' - '), p.id] } }
  filter :event, if: proc { params[:event_id].nil? }

  csv do
    column :id
    column(:patron_name) {|vote| vote.patron.name }
    column(:patron_email) {|vote| vote.patron.email }
    column(:event) {|vote| vote.event.name }
    column :status
    column :created_at
    column :sharing_image
  end
end



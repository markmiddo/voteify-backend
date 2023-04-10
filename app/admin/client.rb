ActiveAdmin.register Client do
  permit_params :email, :password, :password_confirmation, :company_name, :avatar, :type, :fb_url

  actions :index, :show, :edit, :destroy

  index  do
    selectable_column
    id_column
    column :email
    column :company_name
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  controller do
    def update
      super do |success, failure|
        user = User.find(@client.id)
        case user.type
        when 'Admin'
          success.html { redirect_to admin_admin_path(user) }
        when 'Client'
          success.html { redirect_to admin_client_path(user) }
        when 'Patron'
          success.html { redirect_to admin_patron_path(user) }
        end
      end
    end
  end

  show do
    attributes_table do
      rows :email, :company_name, :fb_url
      row(:avatar) {|user| image_tag(user.avatar.versions[:medium].url) unless user.avatar.file.nil? }
    end
    panel 'Events' do
      table_for client.events do
        column(:event) {|event| link_to(event.name, admin_event_path(event)) }
        column :start_date
        column :place
        column(:landing_image) {|event| link_to(image_tag(event.landing_image.versions[:small].url), event.landing_image.url) }
      end
    end
  end

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.input :company_name
      f.input :avatar
      f.input :fb_url
      unless f.object.new_record?
        f.input :type, as: :select, collection: %w(Admin Client Patron)
      end
    end
    f.actions
  end

  csv do
    column :id
    column :email
    column :company_name
    column :sign_in_count
    column :created_at
  end

end

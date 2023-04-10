ActiveAdmin.register Patron do
  permit_params :email, :password, :password_confirmation, :avatar, :type, :fb_url

  actions :index, :show, :edit, :destroy

  controller do
    def update
      super do |success,failure|
        user = User.find(@patron.id)
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

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at


  show do
    attributes_table do
      rows :email, :fb_url
      row(:avatar) {|user| image_tag(user.avatar.versions[:small].url) unless user.avatar.file.nil? }
    end
  end

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.input :fb_url
      f.input :avatar
      unless f.object.new_record?
        f.input :type, as: :select, collection: %w(Admin Client Patron)
      end
    end
    f.actions
  end

  csv do
    column :id
    column :name
    column :email
    column :sign_in_count
    column :created_at
  end

end

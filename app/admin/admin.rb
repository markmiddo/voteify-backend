ActiveAdmin.register Admin do

  permit_params :email, :password, :password_confirmation

  actions :index, :show, :destroy

  index download_links: [nil] do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
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
      rows :email
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      unless f.object.new_record?
        f.input :type, as: :select, collection: %w(Admin Client Patron)
      end
    end
    f.actions
  end

end

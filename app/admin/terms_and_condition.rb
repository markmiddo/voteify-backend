ActiveAdmin.register TermsAndCondition do
  permit_params :title, :body

  actions :index, :show, :edit, :update

  index download_links: [nil] do
    column :title
    column :body
    column :created_at
    actions
  end

  form do |f|
    inputs do
      f.input :title
      f.input :body, as: :text
    end
    f.actions
  end
end

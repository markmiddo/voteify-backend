ActiveAdmin.register AboutUsDetail do
  permit_params :subtitle, :body

  index download_links: [nil] do
    selectable_column
    id_column
    column :subtitle
    column :body
    column :created_at
    actions
  end
end

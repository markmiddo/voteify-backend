ActiveAdmin.setup do |config|

  config.site_title = 'Reminisce'

  config.authentication_method =  :authenticate_admin!

  config.current_user_method = :current_admin

  config.logout_link_path = :destroy_admin_session_path

  config.comments = false

  config.batch_actions = true

  config.localize_format = :long

  config.download_links = [:csv]


end

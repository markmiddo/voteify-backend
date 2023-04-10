Devise.setup do |config|
  config.mailer_sender = ENV['SENDER_EMAIL']
  config.secret_key = ENV['DEVISE_SECRET']
  config.password_length = 6..128
end

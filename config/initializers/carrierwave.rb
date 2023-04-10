CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage = :file
  config.asset_host = ENV['ASSETS_HOST']
end

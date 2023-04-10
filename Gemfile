source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.3'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'devise_token_auth'
gem 'active_model_serializers'
gem 'dotenv-rails'
gem 'carrierwave'
gem 'mini_magick'
gem 'sidekiq', '~>5.0.0'
gem 'rack-cors'
gem 'sprockets', '~> 3.0'
gem 'kaminari'
gem 'annotate'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'letter_opener'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'email_spec'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'bullet'
end

gem 'faker'
gem 'factory_bot_rails'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

gem 'decent_exposure', '3.0.0'
gem 'pundit'
gem 'activeadmin'
gem 'seedbank'
gem 'counter_cache_with_conditions'

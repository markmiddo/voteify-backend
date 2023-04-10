require 'sidekiq/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                                ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
  end
  mount Sidekiq::Web, at: '/sidekiq'
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations:      'auth/registrations',
        sessions:           'auth/sessions',
        token_validations:  'auth/token_validations',
        passwords:          'auth/passwords',
        omniauth_callbacks: 'auth/omniauth_callbacks'
    }
    resources :questions, only: :index
    resources :answers, only: :create
    resources :terms_and_conditions, only: :index
    resources :about_us_details, only: :index
    resources :events, only: %i[show index]
    resources :view_events, only: :create
    resources :visitor_messages, only: :create
    resources :votes, only: :show
    resources :users, only: %i[show update] do
      put 'update_type', action: :update_type
    end
    resources :event_tracks, only: %i[create destroy]
    scope :patron, module: :patron do
        resources :votes, only: %i[create update show index]
        resources :questions, only: %i[index]
    end

    resources :health_check, only: [:index]
  end
end

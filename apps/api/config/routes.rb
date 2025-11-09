require "sidekiq/web"

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      resources :diary_entries do
        collection do
          get :calendar
          get :timeline
        end

        member do
          post :publish
          post :regenerate
        end
      end

      resources :uploads, only: :create

      resources :weekly_digests, only: %i[index show] do
        collection do
          post :generate
        end
      end

      resource :preferences, only: %i[show update]
    end
  end

  root "home#index"

  get "health", to: proc { [200, {}, ["ok"]] }
  get "up" => "rails/health#show", as: :rails_health_check

  if ENV["SIDEKIQ_WEB_USERNAME"].present? && ENV["SIDEKIQ_WEB_PASSWORD"].present?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch("SIDEKIQ_WEB_USERNAME")) &
        ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch("SIDEKIQ_WEB_PASSWORD"))
    end
  end

  Sidekiq::Web.set :session_secret, Rails.application.secret_key_base
  mount Sidekiq::Web => "/sidekiq"
end

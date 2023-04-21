Rails.application.routes.draw do
  apipie

  post "/users", to: "users#create"
  match "/users", to: "users#update", via: [:put, :patch]
  get "/me", to: "users#me"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # resources :tasks do
      #   post "toggle", on: :member
      # end

      # resources :users do
      #   resources :projects, shallow: true
      # end

      resources :projects do
        resources :tasks
      end
    end
  end

  post "/auth/login", to: "authentication#login"
end

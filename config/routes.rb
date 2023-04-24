Rails.application.routes.draw do
  apipie

  post "/users", to: "users#create"
  match "/users", to: "users#update", via: [:put, :patch]
  get "/me", to: "users#me"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      # TODO: shallow ?

      resources :projects do
        resources :tasks do
          resources :comments, only: [:index, :create, :destroy]

          post "toggle", on: :member
        end
      end
    end
  end

  post "/auth/login", to: "authentication#login"
end

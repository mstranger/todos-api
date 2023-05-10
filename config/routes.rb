Rails.application.routes.draw do
  apipie

  get "/me", to: "users#me"
  match "/users", to: "users#update", via: %i[put patch]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      # TODO: shallow ?
      resources :projects do
        resources :tasks do
          resources :comments, only: %i[index create destroy]

          post "toggle", on: :member
        end
      end
    end
  end

  post "/auth/login", to: "authentication#login"
  post "/auth/signup", to: "users#create"
end

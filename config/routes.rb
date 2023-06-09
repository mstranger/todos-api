Rails.application.routes.draw do
  apipie

  get "/", to: ->(env) { [204, {}, [""]] }

  get "/me", to: "users#me"
  match "/users", to: "users#update", via: %i[put patch]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          resources :comments, only: %i[index create destroy]

          post "toggle", on: :member
          post "up", on: :member
          post "down", on: :member
        end
      end
    end
  end

  post "/auth/login", to: "authentication#login"
  post "/auth/signup", to: "users#create"
end

Rails.application.routes.draw do
  apipie
  resources :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tasks
    end
  end

  post "/auth/login", to: "authentication#login"

  get "/me", to: "users#me"
end

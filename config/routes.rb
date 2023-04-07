Rails.application.routes.draw do
  resources :users

  post "/auth/login", to: "authentication#login"

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tasks
    end
  end
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'homes#show'

  resource :home, only: :show

  namespace :slack do
    resource :auth, only: :show
    resources :spins, only: :create
  end

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
end

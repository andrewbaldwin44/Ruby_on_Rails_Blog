Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  resource :session, only: [:new, :create, :destroy]
  post 'session/new', to: 'sessions#create'
  resources :users
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
end

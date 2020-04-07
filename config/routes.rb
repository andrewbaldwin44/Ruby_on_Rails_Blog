Rails.application.routes.draw do
  root to: "articles#index"
  resources :articles do
    resources :comments
  end
  resources :comments
  resources :tags
  resources :users
  resources :user_sessions, only: [ :new, :create, :destroy ]

  get "login" => "user_sessions#new"
  get "logout" => "user_sessions#destroy"
end

Rails.application.routes.draw do

  get "/", to: "application#index"

  resources :withdraws, only: %i[ index show create delete ]
  resources :deposits, param: :id, only: %i[ index show create delete ]
  resources :users, param: :id, only: %i[ create update ]
  resources :sessions, only: %i[ index create ]
  get "/*a", to: "application#not_found"
end

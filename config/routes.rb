Rails.application.routes.draw do
  resources :withdraws
  resources :deposits, param: :id
  resources :users, param: :id
  resources :sessions
  get "/*a", to: "application#not_found"
end

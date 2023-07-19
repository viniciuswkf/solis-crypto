Rails.application.routes.draw do
  resources :deposits
  resources :users, param: :id
  resources :sessions
  get "/*a", to: "application#not_found"
end

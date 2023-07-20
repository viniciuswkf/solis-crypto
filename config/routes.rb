Rails.application.routes.draw do
  resources :deposits, param: :id
  resources :users, param: :id
  resources :sessions
  get "/*a", to: "application#not_found"
end

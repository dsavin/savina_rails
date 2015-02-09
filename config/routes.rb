Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  root to: 'application#coming_soon'
  devise_for :users
  resources :users
end

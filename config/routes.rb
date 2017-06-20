Rails.application.routes.draw do

  get 'cities/show'

  get 'cities/index'

  get 'states/show'

  get 'states/index'

  get 'countries/show'

  get 'countries/index'

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :artists
  resources :concerts
  resources :albums
  resources :users
  resources :venues, only: [:new, :create, :edit, :update, :index, :show]

  get  '/signup', to: 'users#new'
  get  '/login', to: 'sessions#new'
  post  '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end

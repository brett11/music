Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'

  get  '/signup', to: 'users#new'

  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  get  '/login', to: 'sessions#new'
  post  '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

  resources :artists, except: :destroy
  resources :concerts, except: :destroy
  resources :albums, except: :destroy
  resources :venues,except: :destroy
  resources :users, except: :destroy do
    member do
      get :following
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :fanships,       only: [:create, :destroy]
end

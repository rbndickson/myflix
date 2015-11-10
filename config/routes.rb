Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'

  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'forgot_password', to: 'forgot_password#new'
  post 'forgot_password', to: 'forgot_password#create'
  get 'forgot_password_confirmation', to: 'forgot_password#confirmation'
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  get 'home', to: 'videos#index'

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  get 'people', to: 'relationships#index'

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :videos, only: [:show, :index] do
    resources :reviews, only: [:create]

    collection do
      get 'search'
    end
  end

  resources :queue_items, only: [:create, :destroy]
  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :relationships, only: [:create, :destroy]
end

Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'

  get 'register', to: 'users#new'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'home', to: 'videos#index'

  get 'my_queue', to: 'queue_items#index'

  resources :videos, only: [:show, :index] do
    resources :reviews, only: [:create]

    collection do
      get 'search'
    end
  end

  resources :queue_items, only: [:create]
  resources :categories, only: [:show]
  resources :users, only: [:create]
end

Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'
  get 'register', to: 'users#new'

  resources :videos, only: [:show, :index] do
    collection do
      get 'search'
    end
  end


  resources :categories, only: [:show]
  resources :users, only: [:create]
end

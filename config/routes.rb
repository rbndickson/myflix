Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'
  get '/home', to: 'videos#index'

  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
  end


  resources :categories, only: [:show]
end

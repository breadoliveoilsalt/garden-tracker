Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#home'

    # For signing in and out:
  get "/signin", to: "sessions#new"
  post "/sessions/create", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

    # For creation of account through GitHub:
  get '/auth/:provider/callback', to: 'sessions#create_from_github'

  resources :users, only: [:new, :create, :show] do
    resources :gardens, only: [:index, :show] do
      get '/next', to: 'gardens#next'
    end
    resources :species, except: :index
  end

  get 'users/:id/get_garden_ids', to: 'gardens#get_garden_ids'

  get 'gardens/most_plantings', to: 'gardens#most_plantings'
  get 'gardens/largest', to: 'gardens#largest'

  resources :gardens do
    resources :plantings, only: [:new, :create, :destroy]
  end


end

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
    resources :gardens, only: [:index, :show]
    resources :species, except: :index
  end


  resources :gardens do
    resources :plantings, only: [:new, :create]
  end
  # resources :gardens do #do I need only show, edit, etc.?




  resources :plantings, only: [:update, :destroy]# Again, do I need to add only show, etc.?
end

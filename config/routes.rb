Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#home'

  resources :users, only: [:new, :create, :show] do
    resources :gardens, only: [:index, :show]
  end #probably have to modify at some point whether person can delete account etc.

  #get 'callback', to: 'sessions#create_from_github'
  get '/auth/:provider/callback', to: 'sessions#create_from_github'
    # if the above not work, try to replace :provider with github
  get "/signin", to: "sessions#new"
  post "/sessions/create", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

  resources :gardens do
    resources :plantings, only: [:new, :create]
  end
  # resources :gardens do #do I need only show, edit, etc.?
  #   resources :plantings, only: [:index, :show]
  # end

  # really really really think about permissions here and what you might have to block
  resources :species # species is ok as its own resource b/c it is agnostic of the garden...but it isn't agnostic of the user...

  resources :plantings, only: [:update, :destroy]# Again, do I need to add only show, etc.?
end

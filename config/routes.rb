Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#home'

  resources :users #probably have to modify at some point whether person can delete account etc.

  #get 'callback', to: 'sessions#create_from_github'
  get '/auth/:provider/callback', to: 'sessions#create_from_github'
    # if the above not work, try to replace :provider with github
  get "/signin", to: "sessions#new"
  post "/sessions/create", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

  resources :gardens #do I need only show, edit, etc.? 

end

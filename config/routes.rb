Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'items#index'

  resources :merchants
  resources :items do
    resources :reviews, only: [:new, :create]
  end
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:increment_decrement", to: "cart#increment_decrement"

  post "/orders", to: "orders#create"
  get "/orders/:order_id", to: "orders#show"
  patch "/orders/:order_id", to: "orders#cancel"

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  get "/profile/orders/:order_id", to: "orders#show"
  patch "/profile/orders/:order_id/:address_id", to: "orders#update"
  get "/profile", to: "users#show"
  get "/profile/orders", to: "orders#index"
  get '/profile/edit', to: 'users#edit'
  get '/profile/password_edit', to: 'users#password_edit'
  patch '/profile', to: 'users#update'

  get '/profile/addresses/:address_id/edit', to: 'addresses#edit'
  get '/profile/addresses/new', to: 'addresses#new'
  patch '/profile/addresses/:address_id', to: 'addresses#update', as: :update_address
  post '/profile/addresses', to: 'addresses#create', as: :create_address
  delete '/profile/addresses/:address_id', to: 'addresses#destroy'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :merchant do
    get '/', to: "dashboard#index"
    patch '/items/:item_id', to: "items#toggle"
    get '/orders/:order_id', to: "orders#show"
    resources :items
    patch '/itemorders/:id/fulfill', to: "itemorders#fulfill"
  end

  namespace :admin do
    get '/', to: "dashboard#index"
    patch '/orders/:order_id/ship', to: "dashboard#ship"
    get '/users', to: "users#index"
    patch '/merchants/:merchant_id', to: "merchants#toggle"
    get '/merchants/:merchant_id', to: "merchants#show"
    get '/users/:user_id', to: "users#show"
  end
end

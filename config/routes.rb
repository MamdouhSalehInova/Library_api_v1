Rails.application.routes.draw do
  get 'otp/verify'
  resources :reviews
  resources :orders
  resources :books
  resources :categories
  resources :shelves
  resources :authors
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get "accept", to: "orders#accept"
  get "reject", to: "orders#reject"
  get "return", to: "orders#return"
  get "my_orders", to: "orders#my_orders"
  get "borrow", to: "books#borrow"
  get "late", to: "orders#late"
  get 'new_order', to: "orders#create"
  post 'password/create', to: 'password_reset#create'
  put 'password/edit', to: 'password_reset#edit'
  post 'verify_otp', to: 'otp#verify'

  root "books#index"
end

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

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "accept", to: "orders#accept"
  get "reject", to: "orders#reject"
  get "return", to: "orders#return"
  get "my_orders", to: "orders#my_orders"
  get "borrow", to: "books#borrow"
  get "late", to: "orders#late"
  get 'new_order', to: "orders#create"
  post 'password/create', to: 'password_reset#create'
  post 'password/edit', to: 'password_reset#edit'
  post 'verify_otp', to: 'otp#verify'



  # Defines the root path route ("/")
  root "home#index"
end

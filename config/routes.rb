Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  resources :stores
  resources :products
  resources :order_items
  resources :users
  resources :addresses, only: [ :create, :update ]

  get "listing" => "products#listing"
  get "products/store/:store_id" => "products#products_store"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"
  post "new_token" => "registrations#new_token"

  get "orders" => "orders#listing", as: :listing_orders
  get "orders_seller/:id" => "orders#sellers"
  post "change_state" => "orders#change_state"
  post "payments" => "orders#payment"


  scope :buyers do
    resources :orders, only: [ :index, :create, :show, :update ]
  end

  resources :orders, only: [ :destroy, :new, :edit ]

  resources :stores do
    resources :products, only: [:index]
    get "/orders/new" => "stores#new_order"
  end

  resources :orders do
    get "status_order" => "orders#status_order"
  end

  get "last_chat" => "chat_rooms#last_chat"
  resources :chat_rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end


  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check


end

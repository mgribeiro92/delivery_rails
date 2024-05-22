Rails.application.routes.draw do
  devise_for :users
  resources :stores
  resources :products
  resources :order_items

  get "listing" => "products#listing"
  get "products/store/:store_id" => "products#products_store"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"
  post "new_token" => "registrations#new_token"

  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  get "orders_seller/:id" => "orders#sellers"
  post "change_state" => "orders#change_state"

  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

end

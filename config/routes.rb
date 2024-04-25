Rails.application.routes.draw do
  devise_for :users
  resources :stores
  get "listing" => "products#listing"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"
  post "new_token" => "registrations#new_token"

  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

end

Rails.application.routes.draw do
  namespace :api do
    resources :stores
    get "user_store" => "stores#user_store"
  end


end

Rails.application.routes.draw do
  resources :contacts, only: [:new, :index]
  post "contacts/import", to: "contacts#import"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "contacts#index"
end

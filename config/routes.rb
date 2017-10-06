Rails.application.routes.draw do
  get 'home/index'

devise_for :users, controllers: {
        sessions: 'users/sessions',
        registration: 'users/registrations'
      }

#match "/registration" => "devise/registrations#test", via: :get
match "/register" => "users#register", via: :post, as: 'p'
match "users/otp_check" => "users#otp_check", via: :post 
match "users/login" => "users#login", via: :post
match "/properties" => "properties#properties", via: :get
match "/post_property" => "properties#post_property", via: :post
match "/zip_autocomplete" => "properties#zip_autocomplete",via: :get
match "/get_property_details" => "properties#get_property_details",via: :get
match "/property_types" => "properties#property_types", via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

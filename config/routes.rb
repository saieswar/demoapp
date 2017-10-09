Rails.application.routes.draw do
  get 'services/index'

  get 'bids/index'

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
match "/zip_autocomplete" => "home#zip_autocomplete",via: :get
match "/get_property_details" => "properties#get_property_details",via: :get
match "/property_types" => "properties#property_types", via: :get
match "/update_property" => "properties#update_property", via: :post
match "/agent_properties" => "properties#agent_properties", via: :get
match "/services" => "services#index", via: :get 
match "/place_bid" => "bids#place_bid", via: :post
match "/accept_bid" => "bids#accept_bid", via: :post
match "/property_bids" => "properties#property_bids", via: :get
match "/my_agents" => "properties#my_agents", via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

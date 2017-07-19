Rails.application.routes.draw do
  get 'home/index'

devise_for :users, controllers: {
        sessions: 'users/sessions',
        registration: 'users/registrations'
      }

#match "/registration" => "devise/registrations#test", via: :get
match "/register" => "users#register", via: :post
match "users/otp_check" => "users#otp_check", via: :post 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

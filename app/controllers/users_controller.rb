require 'twilio-ruby'

class UsersController < ApplicationController
	def register
    
	 @user = User.new(first_name: params["first_name"],last_name: params["last_name"],date_of_birth: params["date_of_birth"],email: params["email"], password: params["password"], password_confirmation: params["password_confirmation"],phone: params["phone"])
    
    if @user.save 
      response = create_tokens
      render :json => {:success => true, message: "User Registered Successfully!"}.merge!(response)
    else
      render :json=> { :success=>false, :error => @user.errors.full_messages.first }
    end  
  
	end

    def create_tokens
      headers = request.headers
      refresh_token = Digest::MD5.hexdigest(Time.now.to_s + @user.email)
      client_id = headers["HTTP_DEVICE_ID"] rescue nil
      device_token = headers["HTTP_DEVICE_TOKEN"] rescue nil
      otp_secret_key = ROTP::Base32.random_base32
      @user.update(device_id: client_id, token: device_token, otp_secret_key: otp_secret_key, auth_token: refresh_token)
    
      account_sid = 'AC008d129a6e2126f2d5d02a58f41b2796'
      auth_token = 'f832229e425e34349df3090ece9b2547'
      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new account_sid, auth_token
      user_otp = @user.otp_code
      @client.api.account.messages.create(from: '+14153601033',to: '+919493599638',body: "Hey there! #{user_otp}" )
      response = { success: true, user: {first_name: @user.first_name, last_name: @user.last_name, email: @user.email, auth_token: @user.auth_token }}
      
    end
   
   def otp_check
     user = User.find_by_auth_token(params[:auth_token])
     if user.authenticate_otp(params[:otp], drift: 60)
       render json:{success: true, auth_token: user.auth_token, email: user.email}
     else
      render json:{success: true, error: "OTP expired"}
     end
   end


end

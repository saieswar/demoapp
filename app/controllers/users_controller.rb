# require 'twilio-ruby'

class UsersController < ApplicationController
	def register
      #response = create_tokens
      if params[:role].present?
      if params[:role] == "Seller"
        @user = User.new(full_name: params["full_name"],email: params["email"], password: params["password"], password_confirmation: params["password_confirmation"],phone: params["phone"], role_id: Role.find_by(name: "Seller").id)
        @user.save
        puts "seller"
        puts "===================================="
        @user.create_seller
#        @user.update role_id: Role.find_by(name: "Seller").id
      elsif params[:role] == "Agent"
        @user = User.new(full_name: params["full_name"],email: params["email"], password: params["password"], password_confirmation: params["password_confirmation"],phone: params["phone"], role_id: Role.find_by(name: "Agent").id)
        @user.save
        @user.create_agent(agency_name: params[:agency_name], real_estate_license: params[:real_estate_license])
        puts "agent"
      else
        puts "no role sent"
      end

      render :json => {:success => true, message: "User Registered Successfully!"}
    else
      render :json=> { :success=>false, :error => @user.errors.full_messages.first }
    end  
  
	end

  
   def login
   @user = User.find_by(email: params[:email])
  #raise @user.inspect 
   if @user.present?
    if @user.valid_password?(params[:password])
     response = create_tokens
      render :json => {:success => true, message: "login Successfully"}.merge!(response)
    else
      render :json => {:success => false, false: "invalid email or password"}
    end
   else
      render :json => {:success => false, false: "invalid email or password"}
   end
   end




    def create_tokens
      headers = request.headers
      refresh_token = Digest::MD5.hexdigest(Time.now.to_s + @user.email)
      client_id = headers["HTTP_DEVICE_ID"] rescue nil
      device_token = headers["HTTP_DEVICE_TOKEN"] rescue nil
      #otp_secret_key = ROTP::Base32.random_base32
      @user.update(device_id: client_id, token: device_token, auth_token: refresh_token)
    
      #account_sid = 'AC008d129a6e2126f2d5d02a58f41b2796'
      #auth_token = 'f832229e425e34349df3090ece9b2547'
      # set up a client to talk to the Twilio REST API
      #@client = Twilio::REST::Client.new account_sid, auth_token
      #user_otp = @user.otp_code
     # @client.api.account.messages.create(from: '+14153601033',to: '+919493599638',body: "Hey there! #{user_otp}" )
      response = { success: true, user: {full_name: @user.full_name, email: @user.email, auth_token: @user.auth_token, role: "Seller" }}
      
    end
   
   # def otp_check
   #   user = User.find_by_auth_token(params[:auth_token])
   #   if user.authenticate_otp(params[:otp], drift: 60)
   #     render json:{success: true, auth_token: user.auth_token, email: user.email}
   #   else
   #    render json:{success: true, error: "OTP expired"}
   #   end
   # end


end

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end




def test
  {success: true}
end
  def create
    puts "email------------params[:email]"
     #raise params.inspect
    @user = User.create!(first_name: params["first_name"],last_name: params["last_name"],date_of_birth: params["date_of_birth"],email: params["email"], password: params["password"], password_confirmation: params["password_confirmation"],phone: params["phone"])
    if @user 
      response = create_tokens
      render :json => {:success => true, message: "User Registered Successfully!"}.merge!(response)
    else
      render :json=> { :success=>false, :error => @user.errors.full_messages.first }
    end  
  
  end



def method_name
  
end

  def create_tokens
    headers = request.headers
    refresh_token = Digest::MD5.hexdigest(Time.now.to_s + @user.email)
    client_id = headers["HTTP_DEVICE_ID"] rescue nil
    device_token = headers["HTTP_DEVICE_TOKEN"] rescue nil
    @user.update(device_id: client_id, token: device_token,auth_token: refresh_token)
    response = { success: true, auth_token: refresh_token, user: {first_name: @user.first_name, last_name: @user.last_name }}
    
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

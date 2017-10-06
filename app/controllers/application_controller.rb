class ApplicationController < ActionController::API
	#before_action :authenticate_user!
	def authenticate_request!
		#raise request.headers.inspect
  token = request.headers["HTTP_AUTH_TOKEN"]

		 if token
      user = User.find_by_auth_token(token)
     if user.present?
      @current_user = user
      role = user.role.name
      user = { id: user.id, email: user.email, full_name: user.full_name}
      response_token = { :user => user, :role=> role }
      session[:response_token] = response_token
      return session[:response_token]
      # Rails.logger.info "mobile request==============#{device_type}====== #{Time.zone.now}===================================="
    else
      render json: { error: "Not authorized!" }
    end
  else
      render json: { error: "Not authorized!" }
  	
  end

	end
end

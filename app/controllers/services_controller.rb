class ServicesController < ApplicationController
  def index
  	render json: {success: true, services: Service.all.map(&:name)}
  end
end

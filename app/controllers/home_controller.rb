class HomeController < ApplicationController
  def index
  	render json:{sucess: true}
  end
    def zip_autocomplete
   
      @result = []
      
        @zips = Zip.all
        @zips.each do|zip|
          @result << Hash[:city => zip.city, :state => zip.state,:country => zip.country,:label => "#{zip.zip_code}, #{zip.city}, #{zip.state}",:zip => zip.zip_code,:latitude => zip.latitude,:logitude => zip.longitude]
        end
       
      render :json => {:result => @result}    
 
  end
end

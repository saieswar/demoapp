class PropertiesController < ApplicationController
before_filter :authenticate_request!
before_filter :response_token

def response_token
    response_token = session[:response_token] || {}
end


  def properties
    @properties = @current_user.seller.properties
    @response_token = response_token
    #@index = params[:index].present? ?  params[:index].to_i - 1 : 0
    #@property = @properties[@index]
 #   @max_time,@time_remaining = property_time if @property.present?
    if @properties.present?
    render json: {success: true, properties: @properties}.merge!(response_token)
    else

    render json: {success: false, error: "No Properties"}.merge!(response_token)
  end
  end  

  def zip_autocomplete
   
      @result = []
      
        @zips = Zip.all
        @zips.each do|zip|
          @result << Hash[:city => zip.city, :state => zip.state,:country => zip.country,:label => "#{zip.zip_code}, #{zip.city}, #{zip.state}",:zip => zip.zip_code,:latitude => zip.latitude,:logitude => zip.longitude]
        end
       
      render :json => {:result => @result}.merge!(response_token)     
 
  end

def property_types
	render json:{success: true, property_types: PropertyType.all.map(&:name)}
end
def get_property_details
   if params[:property_id].present?
      property = Property.find_by(id: params[:property_id])
      if property.present?
        render :json=> { :success => true, :property => property, :address => property.address, :zip => (property.address.zip if property.address.zip.present? ) }.merge!(response_token)
      else
        render :json => {:success => false, :error => "Property not found" }.merge!(response_token)
      end  
    else
      render :json => {:success => false, :error => "Property parameter is missing" }.merge!(response_token)
    end  
end
  def post_property
    if @current_user.seller.present?
      #min_listing = PropertySetting.where(category: PropertySetting::MinListingsPerAccount).first.value.to_i   
      properties = @current_user.seller.properties
       
  #      full_address = params[:full_address]
        zip=Zip.find_by_zip_code(params[:zip]).id if Zip.find_by_zip_code(params[:zip]).present?
        #@address2 = params[:address2].present? ? params[:address2] : ""
        @address = Address.where(addressable_type: "Property", address1: params[:address],zip_id: zip).last
        unless (@address.present? ? [Property::Bid_Closed, Property::Expired].include?(@address.addressable.status) : true)
          render :json=> { :success => false, :error => "This address is being used by another account" }.merge!(response_token)
        else  
          #property = Property.where(address_request: full_address).first
          seller=@current_user.seller
          property_type_id=PropertyType.find_by_name(params[:property_type]).id if PropertyType.find_by_name(params[:property_type]).present?
          #property_info=params[:facilities]
          #pool, water_front, garage, basement = facilities(property_info)
          #basement_type = params[:basement_type].present? && BasementType.find_by_name(params[:basement_type]).present? ? BasementType.find_by_name(params[:basement_type]).id : nil
          #date = DateTime.strptime(params[:listing_end_date], "%m/%d/%Y") rescue nil
          # super_admin = User.super_admin.first
          # if super_admin.present? && super_admin.allow_property
          property = seller.properties.create(property_type_id: property_type_id,structure_size: params[:structure_size],bedrooms: params[:bedrooms],bathrooms: params[:bathrooms],est_sale_price: params[:est_sale_price],garage: params[:garage], lot_size: params[:lot_size], status: "Open", active: true)
         
          # else
          #   property = seller.properties.create(property_type_id: property_type_id,structure_size: params[:structure_size],bedrooms: params[:bedrooms],bathrooms: params[:bathrooms],est_sale_price: params[:est_sale_price],garage: garage,pool: pool,water_front: water_front,buy_another_property: params[:new_home],licence_agreement: params[:agreement],lot_size: params[:lot_size],status: Property::Hold,basement: basement,garage_doors: params[:spaces],basement_type_id: basement_type,year_built: params[:year_built],list_end_date: date,lot_size_units: params[:lot_size_units],new_property_state: params[:new_property_state],address_request: full_address,subdivision_name: params[:subdivision_name], total_stories: params[:total_stories], style_type_description: params[:style_type_description], formatted_apn: params[:formatted_apn], block_number: params[:block_number], lot_number: params[:lot_number], assd_total_value: params[:assd_total_value], assd_land_value: params[:assd_land_value], assd_improvement_value: params[:assd_improvement_value], tax_amount: params[:tax_amount], tax_year: params[:tax_year], assessed_year: params[:assessed_year], sale_date: params[:sale_date], sale_price: params[:sale_price],price_per_sft: params[:price_per_sft], county: params[:county], school_district: params[:school_district], time_to_market: params[:new_property_time],core_logic_listing_id: params[:core_logic_listing_id])
          # end
          zip=Zip.find_by_zip_code(params[:zip]).id if Zip.find_by_zip_code(params[:zip]).present?
          ActiveRecord::Base.transaction do
            if property            
              property.create_address(address1: params[:address], zip_id: zip)
              # property.update_contact(@current_user)
              #property.create_zoho_seller if Property::ZOHU_AUTH_TOKEN.present?
              #super_admin = User.super_admin.first
              # if super_admin.present? && super_admin.allow_property
              #     UserMailer.notify_accept_property(property).deliver_later
              #    puts  "property_id ====== #{property.id}"
              #     NotifyAgent.perform_async(property.id) 
              #     notify_lp_agents_property(property)
              #     notify_property_accepted(seller,property)  
              #     Property.send_mails_to_first_batch(property)
              # end
            # if mobile_request?
            #   property.photos.destroy_all
            #   if params[:image_urls].present?
            #     params[:image_urls].each do |url|
            #       file_name = url
            #       property.photos.create(small_url: "small_"+file_name, medium_url: "medium_"+file_name, thumb_url: "thumb_"+file_name, large_url: "large_"+file_name) #if !property.photos.count > 5
            #     end
            #   end 
            # end
             # notify_agents_property(property) if property.address.present?
     #         notify_new_property_to_admin(property)
              render :json=> { :success => true, :property => property, :address => property.address}.merge!(response_token)    
            else
              render :json => {:success => false, :error => property.errors.full_messages }.merge!(response_token)   
            end
           end
        end
 

    else
      render :json => {:success => false, :error => "Unauthorized access or your profile is empty" }.merge!(response_token)
    end
  end



end

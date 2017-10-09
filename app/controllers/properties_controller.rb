class PropertiesController < ApplicationController
before_filter :authenticate_request!
before_filter :response_token

def response_token
    response_token = session[:response_token] || {}
end

def agent_properties
  if @current_user.agent
    agent = @current_user.agent 
    @state = agent.address.zip.state rescue @agent.license_state
    zip_ids = Zip.where(state: @state).map(&:id)
    property_ids = Address.where(zip_id: zip_ids,addressable_type: "Property").map(&:addressable_id)
    @total_properties =  Property.where(id: property_ids, status: "Open").where.not(active: false)
     @all_properties = []
     @total_properties.each do |property|
        address1 = property.address.address1 rescue nil
        zip = property.address.zip rescue nil
        city = zip.city rescue nil
        state = zip.state rescue nil
        zip_code = zip.zip_code rescue nil
        property_type = property.property_type.name
        agent = property.bids.where(agent_id: agent.id).count > 0 ? true : false
         @all_properties << {property_id: property.id, property_type: property_type, bedrooms: property.bedrooms, bathrooms: property.bathrooms, lot_size: property.lot_size,
          address: address1, est_sale_price: property.est_sale_price, city: city,
          state: state , zip_code: zip_code, agent_bided: agent, property_status: property.status } 
     end
    render json:{success: true, properties: @all_properties}.merge!(response_token)
  else
    render json:{success: false, error: "Not Authorized"}
  end
end
 

  def properties
    if @current_user.seller
    @properties = @current_user.seller.properties
    @response_token = response_token
    array = []
    #@index = params[:index].present? ?  params[:index].to_i - 1 : 0
    #@property = @properties[@index]
 #   @max_time,@time_remaining = property_time if @property.present?
    if @properties.present?
      @properties.each do|property|
        property_type = property.property_type.name 
        bids_active = property.bids.present?
        address1 = property.address.address1 rescue nil
        zip = property.address.zip rescue nil
        city = zip.city rescue nil
        state = zip.state rescue nil
        zip_code = zip.zip_code rescue nil 
        array << {property_id: property.id, property_type: property_type, bedrooms: property.bedrooms, bathrooms: property.bathrooms, lot_size: property.lot_size,
          address: address1, est_sale_price: property.est_sale_price, city: city,
          state: state , zip_code: zip_code , bids_active: bids_active, bids_count: property.bids.count}
      end
      render json: {success: true, properties: array}.merge!(response_token)
    else
      render json: {success: false, error: "No Properties"}.merge!(response_token)
    end
  else
   render json:{success: false, error: "Not Authorized"}
  end
end

def property_bids
  if current_user.seller
    property = Property.find_by(id: params[:property_id])
    bids = property.bids
    bids_info=[]
    bids.each do|bid|
      address = bid.agent.address.address1 rescue nil
      zip = bid.agent.address.zip rescue nil
      zip_code = zip.zip_code rescue nil
      city = zip.city rescue nil
      state =zip.state rescue nil
      property = bid.property
      address1 = property.address.address1 rescue nil
      city1 = property.address.zip.city  rescue nil
      state1 = property.address.zip.state rescue nil
      zip_code1 = property.address.zip.zip_code  
      property_details = {est_sale_price: property.est_sale_price, property_type: property.property_type.name, address: address1, city1: city1, state1: state1, zip_code1: zip_code1 }
      agent_address = {address: address, city: city, state: state, zip: zip_code}
      bids_info << {property_details: property_details, bid_id: bid.id, bid_status: bid.bid_status.status, bid_percentage: bid.bid_percentage, agency_name: bid.agent.agency_name, real_estate_licensee: bid.agent.real_estate_licensee, agent_name: bid.agent.user.full_name, agent_address: agent_address, bid_services: bid.services.map(&:name), property_status: property.status}
    end
    render json: {success: true , bids_info: bids_info}.merge!(response_token)
  else
    render json: {success: "false", error: "Not Authorized"}
  end
end

def my_agents
  if current_user.seller
    properties = current_user.seller.properties.where(status: Property::Bid_Closed)
   # properties = []
    property_agent_details = []
    puts properties.inspect
    properties.each do|property|
     address = property.address.address1 rescue nil
     zip = property.address.zip rescue nil
     city = zip.city rescue nil 
     zip_code = zip.zip_code rescue nil 
     state = zip.state rescue nil
     bid = property.bids.where(bid_status_id: BidStatus.find_by(status: "Bid Accepted").id).first
     agent = bid.agent
    agent_details = {agency_name: agent.agency_name, address: address, city: city, state: state, zip: zip_code, est_sale_price: property.est_sale_price, phone: agent.user.phone, email: agent.user.email, real_estate_licensee: agent.real_estate_licensee, agent_name: agent.user.full_name, bid_percentage: bid.bid_percentage, property_type: property.property_type.name }
     
    property_agent_details << agent_details
    
    end
 
    render json:{success: true, property_details: property_agent_details}.merge!(response_token)
  else
    render json: {success: false, error: "Not Authorized"}
  end
end

def property_types
	render json:{success: true, property_types: PropertyType.all.map(&:name)}
end
def get_property_details
   if params[:property_id].present?
      property = Property.find_by(id: params[:property_id])
      if property.present?

        bids_active = property.bids.present?
        address1 = property.address.address1 rescue nil
        zip = property.address.zip rescue nil
        city = zip.city rescue nil
        state = zip.state rescue nil
        zip_code = zip.zip_code rescue nil
        property ={property_id: property.id, property_type: property.property_type.name, bedrooms: property.bedrooms, bathrooms: property.bathrooms, lot_size: property.lot_size,
          address: address1, est_sale_price: property.est_sale_price, city: city,
          state: state, zip_code: zip_code, bids_active: bids_active, bids_count: property.bids.count} 
        render :json=> { :success => true, property: property}.merge!(response_token)
      else
        render :json => {:success => false, :error => "Property not found" }.merge!(response_token)
      end  
    else
      render :json => {:success => false, :error => "Property parameter is missing" }.merge!(response_token)
    end  
end

def update_property
  if @current_user.seller.present?
    if params[:property_id].present?
      property = Property.find_by(id: params[:property_id])
       if property
      zip=Zip.find_by_zip_code(params[:zip]).id if Zip.find_by_zip_code(params[:zip]).present?
      property_type_id=PropertyType.find_by_name(params[:property_type]).id if PropertyType.find_by_name(params[:property_type]).present?
      property.update(property_type_id: property_type_id,structure_size: params[:structure_size],bedrooms: params[:bedrooms],bathrooms: params[:bathrooms],est_sale_price: params[:est_sale_price],garage: params[:garage], lot_size: params[:lot_size], status: "Open", active: true)
       if property.address
        property.address.update(address1: params[:address], zip_id: zip)
      else
        property.create_address(address1: params[:address], zip_id: zip)
      end
      render json:{success: true, error: "property updated successfully!"}.merge!(response_token)
      else
        render json:{success: false, error: "no property found with id: #{params[:property_id]}"}
      end
    else
    render json:{success: false, error: "property_id is missing"}

    end
  else
    render json:{success: false, error: "Not Authorized"}
  end
end


  def post_property
    if @current_user.seller.present?
      #min_listing = PropertySetting.where(category: PropertySetting::MinListingsPerAccount).first.value.to_i   
      properties = @current_user.seller.properties
       
  #      full_address = params[:full_address]
        zip=Zip.find_by_zip_code(params[:zip_code]).id if Zip.find_by_zip_code(params[:zip_code]).present?
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

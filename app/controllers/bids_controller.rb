class BidsController < ApplicationController
  before_filter :authenticate_request!
  before_filter :response_token

def response_token
    response_token = session[:response_token] || {}
end

def index
    if @current_user.agent && @current_user.agent.present?
      @all_properties = []
      @agent=@current_user.agent
      @state = @agent.address.zip.state rescue @agent.license_state
      @response_token = response_token
      if params[:status].present?
        status_id=BidStatus.find_by_status(params[:status]).id
        @agent.bids.where(bid_status_id: status_id ,is_repost: false).each do |bid|
          @all_properties << bid.property if @agent.bids.where(property_id: bid.property.id,is_repost: false).first.status == params[:status]
        end    
        @all_properties = @all_properties.uniq
        @properties = request.headers["HTTP_DEVICE_ID"].present? ? Kaminari.paginate_array(@all_properties).page(params[:index].to_i).per(12) : Kaminari.paginate_array(@all_properties).page(params[:index].to_i).per(8)

      else
        invalid_status
      end
    else
       access_denied
    end
end





  def place_bid
    #for placing a bid on the property which can be accessed only by agent
    if params[:property_id].present? && params[:bid_percentage].present? 
      if @current_user.agent && @current_user.agent.present? 
        #property=Property.find_by(id: params[:property_id])
        agent = @current_user.agent
        @agent=@current_user.agent
        property=Property.find_by(id: params[:property_id])
        if property.status != Property::Bid_Closed 
            if @agent.bids.where(property_id: property.id, bid_status_id: BidStatus.find_by(status: "Bid Pending")).present?
              render :json => {:success => false, :message => "already in progress"}.merge!(response_token)
            else    
              bid = property.bids.create :bid_status_id => BidStatus.find_by_status(BidStatus::New).id, :agent_id => @agent.id, :bid_percentage => params[:bid_percentage]
              #bid.property.update status: "Bid Pending"
              #UserMailer.new_bid_mail(bid).deliver_later if bid.agent.accepted?
              #UserMailer.bid_placed_mail(bid.agent,bid.property).deliver_later
             # notify_new_bid(bid)
              #notify_bid_placed(bid)
              if params[:bid_services].present?
                params[:bid_services].each do |service|
                  bid.services << Service.find_by_name(service)
                end
              end
                  #message = @agent.bids.where(payment_status: "Failed",bid_status_id: 4).present? ? "" : "Your bid has been successfully placed"
              render :json => {:success => true,:bid => bid,:message => "Your bid has been successfully placed",:services => bid.services }.merge!(response_token)              
            end
        else
          render :json => {:success => false, :error => "Property bidding already closed" }.merge!(response_token)
        end
      else
          render :json => {:success => false, :error => "Not Authorized!" }.merge!(response_token)
      end
    else
      render json:{success: false, error: "please send bid_percentage, property_id" }
    end
  end

  def accept_bid
    if params[:bid_id].present? 
      if @current_user.seller && @current_user.seller.present?
        bid = Bid.find_by(id: params[:bid_id])
        property=bid.property
        seller=@current_user.seller
        if property.seller == seller
          if property.bids.where(:bid_status_id => BidStatus.where(:status => [BidStatus::Accept, BidStatus::Close]).map(&:id)).count == 1
            render :json => {:success => false, :error => "Bid was Already Accepted " }.merge!(response_token)
          else
            agent = bid.agent
            ##@pending_payments_count = agent.bids.where(payment_status: "Payment Failed",bid_status_id: BidStatus.find_by_status(BidStatus::Close).id).count >= 1 
            #captured = bid.accept_bid_payment
            #bid.close_bid
            bid.property.update(status: Property::Bid_Closed)
            #lead = Lead.create(bid_id: bid.id, status: Lead::New)
             bid.update bid_status_id: BidStatus.find_by(status: "Bid Accepted").id
             bid_status = bid.bid_status.status

            bids = property.bids.where.not(id: bid.id)
            bids.each do |bid|
              bid.update(:bid_status_id => BidStatus.find_by_status(BidStatus::Reject).id)
              user = bid.agent.user
              #UserMailer.agent_bid_rejected_mail(bid,user).deliver_later
              #notify_bid_rejected(bid)
            end 
            #UserMailer.bid_won_mail(bid).deliver_later
            #UserMailer.seller_agent_mail(bid).deliver_later
            #notify_bid_won(bid)
            render json: {success: true,message: "Bid accepted successfully, shortly the selected agent will contact you", bid_status: bid_status, property_status: property.status}.merge!(response_token)
          end
        else
          render json:{success: false, error: "Not Authorized you are trying to login to other seller Account"}.merge!(response_token)
        end
      else
        render json: {success: false, error: "Not Authorized"}.merge!(response_token)
      end
    else
      render json: {success: false, error: "Not Authorized"}
    end
  end



end

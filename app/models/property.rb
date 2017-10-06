class Property < ApplicationRecord
 belongs_to :seller
 has_one :address, :as => :addressable, :dependent => :destroy
	has_one :zip, :through => :address
	has_many :agents, :through => :bids
   Hold = "Hold"
  Open = "Open"
  Obtaining_Offers = "Obtaining Offers"
  Obtaining_Offers_Extended = "Obtaining Offers Extended"
  Select_Offers = "Select Offers"
  # Select_Offers_Extended = "Select Offers Extended"
  Bid_Accepted = "Bid Accepted"
  Bid_Closed = "Bid Closed"
  Invalid = "Reject"
  Expired = "Expired"
  PaymentUnderProcess = "Payment Under Process"
  Radius = 30
  Suspend = "Suspend"
  # Select_Offer_Extended_To = "Select Offer Extended To"

  STATUSES_LIST = [Hold,Obtaining_Offers,Obtaining_Offers_Extended,Select_Offers,Bid_Accepted,Bid_Closed,Expired,Invalid,Suspend]

  ALL_STATUSES = ["New", "All", "Not Interested"]

  default_scope {order("created_at DESC")}
  
end

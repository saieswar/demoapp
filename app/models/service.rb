class Service < ApplicationRecord
  has_many :bid_services, :dependent => :destroy
  has_many :bids, :through => :bid_services, :class_name => "BidService"

end

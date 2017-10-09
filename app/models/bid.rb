class Bid < ApplicationRecord
  has_one :seller, :through => :property
  belongs_to :agent
  belongs_to :property
  belongs_to :bid_status
  has_many :bid_services, :dependent => :destroy
  has_many :services, :through => :bid_services
  New = "Bid Pending"
	Accept = "Bid Accepted"
	Reject = "Bid Rejected"
	Close = "Bid Won"
	Bid_Closed = "Bid Lost"
	Cancel = "Bid Cancelled"


end

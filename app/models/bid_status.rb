class BidStatus < ApplicationRecord
	has_many :bids
	New = "Bid Pending"
	Accept = "Bid Accepted"
	Reject = "Bid Rejected"
	Close = "Bid Won"
	Bid_Closed = "Bid Lost"
	Cancel = "Bid Cancelled"
	
end

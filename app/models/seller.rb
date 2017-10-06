class Seller < ApplicationRecord
	belongs_to :user
	#has_many :properties
	  has_many :properties, :dependent => :destroy
  has_many :bids, :through => :properties
  has_many :agents, :through => :bids
end

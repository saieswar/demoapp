class Agent < ApplicationRecord
	has_many :bids, :dependent => :destroy
	has_one :address, through: :user
	has_many :properties, :through => :bids
	belongs_to :user,:dependent => :destroy
	
end

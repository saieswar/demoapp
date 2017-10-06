class Bid < ApplicationRecord
  has_one :seller, :through => :property
  belongs_to :agent
  belongs_to :property
end

class Address < ApplicationRecord
  belongs_to :zip
  belongs_to :addressable, :polymorphic => true
end

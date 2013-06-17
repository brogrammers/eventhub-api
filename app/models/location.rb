class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude

  belongs_to :locationable, :polymorphic => true
end

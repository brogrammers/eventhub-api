class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude

  belongs_to :locationable, :polymorphic => true

  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }
end

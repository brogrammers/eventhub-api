class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :city, :country

  belongs_to :locationable, :polymorphic => true

  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }, allow_nil: false, allow_blank: false, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }, allow_nil: false, allow_blank: false, presence: true

  validates_with EventhubApi::Validator::Location

  class << self
    def all_within(latitude, longitude, offset)
      center_point = [latitude, longitude]
      box = Geocoder::Calculations.bounding_box(center_point, offset)
      Location.within_bounding_box(box)
    end
  end

  reverse_geocoded_by :latitude, :longitude do |record,results|
    geo = results.first
    if geo
      record.city    = geo.city
      record.country = geo.country
    end
  end

  before_validation :reverse_geocode, :unless => lambda { self.city and self.country }
end

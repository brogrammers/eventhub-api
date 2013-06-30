class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :city, :country

  belongs_to :locationable, :polymorphic => true

  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }

  before_validation :find_location, :unless => lambda { self.city and self.country }

  validates_with EventhubApi::Validator::Location

  private

  def find_location
    result = Geocoder.search("#{self.latitude},#{self.longitude}")
    unless result.empty? or (result.first.city.nil? and result.first.country.nil?)
      self.city = result.first.city
      self.country = result.first.country
    end
  end
end

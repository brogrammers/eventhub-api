class Place < ActiveRecord::Base
  attr_accessible :city, :country, :description, :name

  has_one :location, :as => :locationable
end

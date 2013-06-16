class Place < ActiveRecord::Base
  attr_accessible :city, :country, :description, :name
end

class Place < ActiveRecord::Base
  attr_accessible :city, :country, :description, :name
  has_one :location, :as => :locationable, :dependent => :destroy

  #detinations stuff, save destination object & reload place before you can see this being updated
  has_many :destinations, :as => :choice, :foreign_key => 'choice_id'
end

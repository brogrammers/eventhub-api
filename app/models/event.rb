class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :name, :start_time

  #detinations stuff, save destination object & reload place before you can see this being updated,
  #make sure both destination AND event have their id's assigned
  has_many :destinations, :as => :choice, :dependent => :destroy
end

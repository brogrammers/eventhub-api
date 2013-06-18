class Place < ActiveRecord::Base
  attr_accessible :city, :country, :description, :name
  has_one :location, :as => :locationable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  #detinations stuff, save destination object & reload place before you can see this being updated
  #make sure both destination AND place have their id's assigned
  has_many :destinations, :as => :choice, :foreign_key => 'choice_id', :dependent => :destroy

  has_many :offers ,:as => :offerer, :dependent => :destroy

end

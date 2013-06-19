class LocationPost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  has_one :location, :as => :locationable, :dependent => :destroy
end

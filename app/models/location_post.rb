class LocationPost < ActiveRecord::Base
  belongs_to :user
  has_one :location, :as => :locationable, :dependent => :destroy
end

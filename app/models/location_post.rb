class LocationPost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  has_one :location, :as => :locationable, :dependent => :destroy

  validates :user, :location, :content, :presence => true
  validates :content, :length => { :minimum => 5, :maximum => 512 }

end

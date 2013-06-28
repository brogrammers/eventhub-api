class CoreUser < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :name

  has_many :devices, :as => :device_compatible, :dependent => :destroy

  validates :name, :presence => true
end
class CoreUser < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :name

  has_many :devices, :as => :device_compatible, :dependent => :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :identities, :as => :identifiable, :dependent => :destroy

  validates_with EventhubApi::Validator::Identity

  validates :name, :presence => true

  has_many :places, :as => :creator, :dependent => :destroy

end
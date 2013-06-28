class CoreUser < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :name

  has_many :identities, :as => :identifiable, :dependent => :destroy

  validates :name, :presence => true
end
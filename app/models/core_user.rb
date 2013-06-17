class CoreUser < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :name

  validates :name, :presence => true
end
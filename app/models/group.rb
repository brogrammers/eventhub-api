class Group < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :destinations, :dependent => :destroy
end

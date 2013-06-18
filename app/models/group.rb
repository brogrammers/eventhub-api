class Group < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :destinations, :dependent => :destroy

  has_many :group_members
  has_many :members, :through => :group_members, :source => :user
end

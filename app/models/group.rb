class Group < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :destinations, :dependent => :destroy

  belongs_to :user

  has_many :group_members
  has_many :members, :through => :group_members, :source => :user

  has_many :pending_members
  has_many :invited, :through => :pending_members, :source => :user
end

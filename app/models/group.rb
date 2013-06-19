class Group < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :destinations, :dependent => :destroy

  validates :description, :name, :presence => true

  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  has_many :group_members, :dependent => :destroy
  has_many :members, :through => :group_members, :source => :user

  has_many :pending_members, :dependent => :destroy
  has_many :invited, :through => :pending_members, :source => :user
end

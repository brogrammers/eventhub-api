class User < ActiveRecord::Base
  inherits_from :core_user
  attr_accessible :availability, :registered, :registered_at

  has_one :location, :as => :locationable, :dependent => :destroy

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :friend

  has_many :group_memberships, :class_name => 'GroupMember'
  has_many :groups, :through => :group_members

  validates :availability, :registered, :registered_at, :presence => true
end
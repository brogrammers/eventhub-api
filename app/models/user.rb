class User < ActiveRecord::Base
  inherits_from :core_user
  attr_accessible :availability, :registered, :registered_at

  has_one :location, :as => :locationable, :dependent => :destroy

  has_many :friendships, :class_name => 'Friendship', :foreign_key => 'member_id'
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :friend

  has_many :groups_created, :class_name => 'Group', :dependent => :destroy

  has_many :group_memberships, :class_name => 'GroupMember', :dependent => :destroy
  has_many :groups_member_of, :source => :group, :through => :group_memberships

  has_many :group_invitations, :class_name => 'PendingMember', :dependent => :destroy
  has_many :groups_invited_to, :source => :group, :through => :group_invitations

  has_many :location_posts, :dependent => :destroy

  validates :registered, :registered_at, :presence => true
end
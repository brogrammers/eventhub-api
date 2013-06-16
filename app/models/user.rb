class User < ActiveRecord::Base
  inherits_from :core_user
  attr_accessible :availability, :registered, :registered_at

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :friend
end
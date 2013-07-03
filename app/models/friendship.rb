class Friendship < ActiveRecord::Base
  attr_accessible :friend_id, :member_id

  belongs_to :member, :class_name => 'User'
  belongs_to :friend, :class_name => 'User'
end

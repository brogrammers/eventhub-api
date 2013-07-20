class Group < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :destinations, :dependent => :destroy

  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  has_many :group_members, :dependent => :destroy
  has_many :members, :through => :group_members, :source => :user

  has_many :pending_members, :dependent => :destroy
  has_many :invited, :through => :pending_members, :source => :user

  has_one :chatroom, :dependent => :destroy

  before_validation :generate_chatroom, :unless => lambda { self.chatroom }

  validates :description, :name, :creator, :chatroom, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with EventhubApi::Validator::Group

  def can_be_modified_by?(user)
    user == creator
  end

  def can_be_seen_by?(user)
    user == creator or members.include? user or invited.include? user
  end

  def generate_chatroom
    self.chatroom = Chatroom.new
    self.chatroom.group = self
  end

  def invite_user!(user, by_user)
    if user.is_member_of? self or user.is_invited_to? self or not user.is_friend_of? by_user
      false
    else
      invited << user
      true
    end
  end

  def accept_invitation(user)
    if user.is_invited_to? self
      invited.delete user
      members << user
    else
      false
    end
  end

  def decline_invitation(user)
    if user.is_invited_to? self
      invited.delete user
      true
    else
      false
    end
  end
end

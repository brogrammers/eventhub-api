class Group < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :destinations, :dependent => :destroy

  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  has_many :group_members, :dependent => :destroy
  has_many :members, :through => :group_members, :source => :user

  has_many :pending_members, :dependent => :destroy
  has_many :invited, :through => :pending_members, :source => :user

  has_one :chatroom, :dependent => :destroy

  validates :description, :name, :creator, :chatroom,  :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with EventhubApi::Validator::Group

  def can_be_modified_by?(user)
    return user == creator
  end

  def can_be_seen_by?(user)
    return ( user == creator or group_members.include? user or pending_members.include? user )
  end
end

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

  def invite_user(user, by_user)
    if by_user == creator or by_user.is_member_of? self
      if not (user.is_invited_to? self) and not (user.is_member_of? self) and not user == creator
        self.invited << user
        self.save!
        user
      else
        raise ActiveRecord::RecordInvalid.new(self)
      end
    else
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def accept_invitation(user)
    if user.is_invited_to? self
      self.members << user
      self.invited.delete user
      self.save!
      user
    else
       raise ActiveRecord::RecordInvalid.new(self)
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

  def remove_member(member, by_user)
    if member == by_user or by_user == creator
      if member.is_member_of? self
        self.members.delete member
        self.save!
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      raise ActiveRecord::RecordInvalid.new(self)
    end

  end

  def generate_chatroom
    self.chatroom = Chatroom.new
    self.chatroom.group = self
  end

end

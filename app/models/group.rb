class MembersCreatorInvitedValdiator < ActiveModel::Validator
  def validate(record)
    all_users = record.members + record.invited << record.creator
    unless all_users.length == all_users.uniq.length
      record.errors[:members] << 'Single user can only belong to creator or members or invited'
      record.errors[:invited] << 'Single user can only belong to creator or members or invited'
      record.errors[:creator] << 'Single user can only belong to creator or members or invited'
    end
  end
end

class Group < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :destinations, :dependent => :destroy

  belongs_to :creator, :class_name => 'User', :foreign_key => 'user_id'

  has_many :group_members, :dependent => :destroy
  has_many :members, :through => :group_members, :source => :user

  has_many :pending_members, :dependent => :destroy
  has_many :invited, :through => :pending_members, :source => :user

  has_one :chatroom, :dependent => :destroy

  validates :description, :name, :creator, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with MembersCreatorInvitedValdiator
end

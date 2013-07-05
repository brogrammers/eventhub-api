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

  validates :description, :name, :creator, :chatroom,  :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with EventhubApi::Validator::Group

  def generate_chatroom
    self.chatroom = Chatroom.new
    self.chatroom.group = self
  end
end

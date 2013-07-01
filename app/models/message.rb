class Message < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  belongs_to :chatroom

  validates :user, :chatroom, :content, :presence => true
  validates :content, :length => { :minimum => 1, :maximum => 10000 }
  validates_with EventhubApi::Validator::Message, :if => lambda { self.chatroom and self.chatroom.group }
end

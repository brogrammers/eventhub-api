class Chatroom < ActiveRecord::Base
  belongs_to :group
  has_many :messages, :dependent => :destroy
  validates :group, :presence => true
end

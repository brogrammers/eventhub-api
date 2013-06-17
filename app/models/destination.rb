class Destination < ActiveRecord::Base
  has_one :creator, :class_name => 'User'

  has_many :votes
  has_many :voters, :class_name => 'User', :through => :votes, :source => :user

  belongs_to :group
end

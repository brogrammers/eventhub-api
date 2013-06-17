class Destination < ActiveRecord::Base
  has_one :creator, :class_name => 'User'
  has_many :votes, :dependent => :destroy
  has_many :voters, :class_name => 'User', :through => :votes, :source => :user

  belongs_to :choice, :polymorphic => :true
end

class Destination < ActiveRecord::Base
  has_one :creator, :class_name => 'User', :foreign_key => 'core_user_id'
  has_many :votes, :dependent => :destroy
  has_many :voters, :class_name => 'User', :through => :votes, :source => :user

  belongs_to :choice, :polymorphic => :true
  belongs_to :group
end

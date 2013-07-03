class Destination < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'core_user_id'
  has_many :votes, :dependent => :destroy
  has_many :voters, :class_name => 'User', :through => :votes, :source => :user

  belongs_to :choice, :polymorphic => :true
  belongs_to :group

  validates :creator, :choice, :group, :presence => true
  validates_with EventhubApi::Validator::Destination
end

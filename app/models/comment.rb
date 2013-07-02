class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :content, :rating, :user, :commentable, :presence => true
  validates :content, :length => {:minimum => 5, :maximum => 1024}
  validates :rating, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
end

class Comment < ActiveRecord::Base
  attr_accessible :content, :rating, :user
  belongs_to :commentable, :polymorphic => true

  #TODO: What should be done when the user is deleted?
  belongs_to :user
end

class GroupMember < ActiveRecord::Base
  attr_accessible :trackable
  belongs_to :group
  belongs_to :user
end

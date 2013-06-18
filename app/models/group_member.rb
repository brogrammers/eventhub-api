class GroupMember < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :group
  belongs_to :user
end

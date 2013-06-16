class RenameColumnUserIdToMemberIdInFriendship < ActiveRecord::Migration
  def up
    rename_column :friendships, :user_id, :member_id
  end

  def down
    rename_column :friendships, :member_id, :user_id
  end
end

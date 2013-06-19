class RenameGroupIdToUserIdOnGroupTable < ActiveRecord::Migration
  def up
    rename_column :groups, :group_id, :user_id
  end

  def down
    rename_column :groups, :user_id, :group_id
  end
end

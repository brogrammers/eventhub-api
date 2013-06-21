class AddGroupToChatroom < ActiveRecord::Migration
  def change
    add_column :chatrooms, :group_id, :integer
  end
end

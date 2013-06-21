class AddChatroomAndDataToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :chatroom_id, :integer
    add_column :messages, :user_id, :integer
  end
end

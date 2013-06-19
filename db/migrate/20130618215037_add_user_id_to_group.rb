class AddUserIdToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_id, :integer
  end
end

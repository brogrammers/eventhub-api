class CreatePendingMembers < ActiveRecord::Migration
  def change
    create_table :pending_members do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
  end
end

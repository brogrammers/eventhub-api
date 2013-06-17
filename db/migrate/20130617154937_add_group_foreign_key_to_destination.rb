class AddGroupForeignKeyToDestination < ActiveRecord::Migration
  def change
    change_table :destinations do |t|
      t.integer :group_id
    end
  end
end

class RenameForeignKeyColumnOnPlace < ActiveRecord::Migration
  def up
    rename_column :places, :core_user_id, :creator_id
  end

  def down
    rename_column :places, :creator_id, :core_user_id
  end
end

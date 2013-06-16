class RenameUserModels < ActiveRecord::Migration
  def up
    rename_table :users, :core_users
    rename_table :members, :users
    rename_table :business_members, :business_users
  end

  def down
    rename_table :business_users, :business_members
    rename_table :users, :members
    rename_table :core_users, :users
  end
end

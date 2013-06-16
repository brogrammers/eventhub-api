class DropAndReCreateUserRelatedTables < ActiveRecord::Migration
  def change
    drop_table :users
    drop_table :core_users
    drop_table :business_users
    create_table :core_users do |t|
      t.string :name
      t.string :subtype, :null => false
    end
    create_table :users, :inherits => :core_user do |t|
      t.boolean :availability
      t.boolean :registered
      t.timestamp :registered_at

      t.timestamps
    end
    create_table :business_users, :inherits => :core_user do |t|

      t.timestamps
    end
  end
end

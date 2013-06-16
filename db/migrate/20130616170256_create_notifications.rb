class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.boolean :read
      t.string :payload

      t.timestamps
    end
  end
end

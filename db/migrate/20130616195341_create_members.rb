class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, :inherits => :user do |t|
      t.boolean :availability
      t.boolean :registered
      t.timestamp :registered_at

      t.timestamps
    end
  end
end

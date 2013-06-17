class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.timestamps
      t.integer :user_id
      t.integer :destination_id
    end
  end
end

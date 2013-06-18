class CreateLocationPosts < ActiveRecord::Migration
  def change
    create_table :location_posts do |t|
      t.integer :user_id
      t.string :content
      t.timestamps
    end
  end
end

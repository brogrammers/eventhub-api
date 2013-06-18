class CreateLocationPosts < ActiveRecord::Migration
  def change
    create_table :location_posts do |t|

      t.timestamps
    end
  end
end

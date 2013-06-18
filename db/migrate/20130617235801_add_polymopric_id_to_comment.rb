class AddPolymopricIdToComment < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.integer :commentable_id
      t.string  :commentable_type
    end
  end
end

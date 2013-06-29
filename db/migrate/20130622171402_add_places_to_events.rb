class AddPlacesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :place_id, :integer
  end
end

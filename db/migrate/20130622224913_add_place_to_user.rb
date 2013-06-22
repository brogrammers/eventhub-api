class AddPlaceToUser < ActiveRecord::Migration
  def change
    add_column :places, :core_user_id, :integer
  end
end

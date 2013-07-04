class AddCreatorToDestination < ActiveRecord::Migration
  def change
    add_column :destinations, :core_user_id, :integer
  end
end

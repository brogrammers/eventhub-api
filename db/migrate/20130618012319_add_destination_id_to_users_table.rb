class AddDestinationIdToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :destination_id, :integer
  end
end

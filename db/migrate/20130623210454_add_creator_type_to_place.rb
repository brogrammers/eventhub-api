class AddCreatorTypeToPlace < ActiveRecord::Migration
  def up
    add_column :places, :creator_type, :string
  end

  def down
    remove_column :places, :creator_type
  end
end

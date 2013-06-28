class RemoveLocationableIdAndTypeFromPlace < ActiveRecord::Migration
  def up
    remove_column :places, :locationable_id
    remove_column :places, :locationable_type
  end

  def down
    add_column :places, :locationable_id, :integer
    add_column :places, :locationable_type, :string
  end
end

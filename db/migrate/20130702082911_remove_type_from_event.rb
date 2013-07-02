class RemoveTypeFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :visibility_type
  end
end

class AddTypeToEventAndPlace < ActiveRecord::Migration
  def change
    add_column :places, :visibility_type, :string
    add_column :events, :visibility_type, :string
  end
end

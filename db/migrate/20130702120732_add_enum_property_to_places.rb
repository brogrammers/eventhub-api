class AddEnumPropertyToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :visibility_type_cd, :integer
  end
end

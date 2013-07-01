class RemoveCityAndCountryFieldsFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :city
    remove_column :places, :country
  end
end

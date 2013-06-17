class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.timestamps
    end
  end
end

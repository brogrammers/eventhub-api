class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :name
      t.string :description
      t.string :price
      t.string :currency
      t.date :start_time
      t.date :end_time

      t.timestamps
    end
  end
end

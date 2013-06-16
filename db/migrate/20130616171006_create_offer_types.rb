class CreateOfferTypes < ActiveRecord::Migration
  def change
    create_table :offer_types do |t|
      t.string :name

      t.timestamps
    end
  end
end

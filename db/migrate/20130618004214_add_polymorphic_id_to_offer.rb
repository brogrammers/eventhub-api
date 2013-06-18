class AddPolymorphicIdToOffer < ActiveRecord::Migration
  def change
    change_table :offers do |t|
      t.integer :offerer_id
      t.string  :offerer_type
    end
  end
end

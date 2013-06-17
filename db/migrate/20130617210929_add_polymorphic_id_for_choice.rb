class AddPolymorphicIdForChoice < ActiveRecord::Migration
  def change
    change_table :destinations do |t|
      t.integer :choice_id
      t.string  :choice_type
    end
  end
end

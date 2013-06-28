class AddPolymorphicAssociationForIdentities < ActiveRecord::Migration
  def up
    change_table :identities do |t|
      t.references :identifiable, :polymorphic => true
    end
  end

  def down
    change_table :identities do |t|
      t.remove_references :identifiable, :polymorphic => true
    end
  end
end

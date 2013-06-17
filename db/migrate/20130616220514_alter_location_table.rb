class AlterLocationTable < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.integer :locationable_id
      t.string :locationable_type
    end
    change_table :users do |t|
      t.references :locationable, :polymorphic => true
    end
    change_table :places do |t|
      t.references :locationable, :polymorphic => true
    end
  end
end

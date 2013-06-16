class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider_id
      t.string :token

      t.timestamps
    end
  end
end

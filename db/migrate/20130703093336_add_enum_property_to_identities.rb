class AddEnumPropertyToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :provider_cd, :integer
  end
end

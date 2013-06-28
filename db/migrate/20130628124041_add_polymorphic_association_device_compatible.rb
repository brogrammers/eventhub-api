class AddPolymorphicAssociationDeviceCompatible < ActiveRecord::Migration
  def change
    add_column :devices, :device_compatible_id, :integer
    add_column :devices, :device_compatible_type, :string
  end
end

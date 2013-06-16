class CreateBusinessMembers < ActiveRecord::Migration
  def change
    create_table :business_members, :inherits => :user do |t|

      t.timestamps
    end
  end
end

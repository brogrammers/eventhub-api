class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :subtype, :null => false
    end
  end
end

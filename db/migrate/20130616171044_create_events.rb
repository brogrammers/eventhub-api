class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.date :start_time
      t.date :end_time

      t.timestamps
    end
  end
end

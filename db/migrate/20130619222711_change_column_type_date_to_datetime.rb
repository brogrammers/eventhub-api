class ChangeColumnTypeDateToDatetime < ActiveRecord::Migration
  def change
    change_column :events, :start_time, :datetime
    change_column :events, :end_time, :datetime
    change_column :offers, :start_time, :datetime
    change_column :offers, :end_time, :datetime
  end
end

class AddRegularEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :regular_end_time, :datetime
  end
end

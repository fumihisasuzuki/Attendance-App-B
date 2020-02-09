class AddOvertimeFinishAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_finish_at, :datetime
  end
end

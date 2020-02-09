class RemoveOvertimeFinishAtFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :overtime_finish_at, :datetime
  end
end

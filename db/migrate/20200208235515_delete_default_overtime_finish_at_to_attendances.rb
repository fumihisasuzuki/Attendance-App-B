class DeleteDefaultOvertimeFinishAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column_default :attendances, :overtime_finish_at, from: "2019-12-28 08:00:00", to: nil
  end
end

class AddAInfoToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :status, :integer, default:0
    add_column :attendances, :approver, :string
    add_column :attendances, :status_one_month, :integer, default:0
    add_column :attendances, :approver_one_month, :string
    add_column :attendances, :overtime_finish_at, :datetime, default: Time.current.change(hour: 17, min: 00, sec: 0)
    add_column :attendances, :overtime_status, :integer, default:0
    add_column :attendances, :overtime_approver, :string
    add_column :attendances, :overtime_note, :string
  end
end

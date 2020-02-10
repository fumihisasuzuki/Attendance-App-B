class AddStartedAtApplyingToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at_applying, :datetime
    add_column :attendances, :finished_at_applying, :datetime
    add_column :attendances, :approved_on, :date
  end
end

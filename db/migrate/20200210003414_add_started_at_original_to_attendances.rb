class AddStartedAtOriginalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at_original, :datetime
    add_column :attendances, :finished_at_original, :datetime
  end
end

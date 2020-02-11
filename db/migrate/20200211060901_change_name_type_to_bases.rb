class ChangeNameTypeToBases < ActiveRecord::Migration[5.1]
  def change
    rename_column :bases, :type, :place_type_status
  end
end

class AddDefaultToBases < ActiveRecord::Migration[5.1]
  def change
    change_column_default :bases, :type, from: nil, to: 0
  end
end

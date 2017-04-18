class ChangeDateAndTimeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :concerts, :dateAndTime, :datandtime
  end
end

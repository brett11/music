class ChangeDateAndTimeColumnNameFix < ActiveRecord::Migration[5.0]
  def change
    rename_column :concerts, :datandtime, :dateandtime
  end
end

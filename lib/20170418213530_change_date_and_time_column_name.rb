class ChangeDateAndTimeColumnName < ActiveRecord::Migration[5.0]
# below commented out because migration already completed for dev
# but prod doesnt need this migration

=begin
  def change
    rename_column :concerts, :dateAndTime, :datandtime
  end
=end
end

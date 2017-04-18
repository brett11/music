class AddJointIndexToOtherJoinTables < ActiveRecord::Migration[5.0]

  def change
    add_index :artists_users, [:artist_id, :user_id]
    add_index :albums_artists, [:album_id, :artist_id]
  end

end

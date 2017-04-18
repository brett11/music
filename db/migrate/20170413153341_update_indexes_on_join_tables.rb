class UpdateIndexesOnJoinTables < ActiveRecord::Migration[5.0]
  def change
    remove_index :artists_concerts, [:artist_id, :concert_id]
    remove_index :artists_users, [:artist_id, :user_id]
    remove_index :albums_artists, [:album_id, :artist_id]
    add_index :artists_concerts, [:artist_id, :concert_id], unique: true
    add_index :artists_users, [:artist_id, :user_id], unique: true
    add_index :albums_artists, [:album_id, :artist_id], unique: true
  end
end

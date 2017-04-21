class AddImageToAlbums < ActiveRecord::Migration[5.0]
  def up
    add_attachment :albums, :album_cover
  end

  def down
    remove_attachment :albums, :album_cover
  end
end

class AddImageToArtists < ActiveRecord::Migration[5.0]
  def up
    add_attachment :artists, :avatar
  end

  def down
    remove_attachment :artists, :avatar
  end
end

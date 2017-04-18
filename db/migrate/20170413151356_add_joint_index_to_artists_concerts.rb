class AddJointIndexToArtistsConcerts < ActiveRecord::Migration[5.0]
  #http://stackoverflow.com/questions/19473044/rails-4-many-to-many-association-not-working
  def change
    add_index :artists_concerts, [:artist_id, :concert_id]
  end
end

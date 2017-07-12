class Fanship < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :artist, class_name: "Artist"
  validates :user_id, presence: true
  validates :artist_id, presence: true
end

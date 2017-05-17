class Song < ApplicationRecord
  belongs_to :album
  validates :album_id, presence: true
end

class Song < ApplicationRecord
  belongs_to :album
  validates :album_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
end

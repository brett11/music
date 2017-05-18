class Concert < ApplicationRecord
  belongs_to :venue
  validates :venue_id, presence: true
  has_and_belongs_to_many :artists
  validates :artist_id, presence: true
end

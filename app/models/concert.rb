class Concert < ApplicationRecord
  belongs_to :venue
  validates :venue_id, presence: true
  has_and_belongs_to_many :artists
  validates :artist_ids, presence: true
  validates :dateandtime, presence: true
end

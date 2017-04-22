class Venue < ApplicationRecord
  belongs_to :city
  has_many :concerts
  validates :name, presence: true, length: { maximum: 60 }
end

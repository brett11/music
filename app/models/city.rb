class City < ApplicationRecord
  belongs_to :state
  belongs_to :country
  has_many :venues
  validates :name, presence: true, length: { maximum: 45 }
end

class Venue < ApplicationRecord
  belongs_to :city
  validates :city_id, presence: true
  has_many :concerts
  validates :name, presence: true, length: { maximum: 60 }

  def self.new_from_controller(params)
    new(params)
  end
end

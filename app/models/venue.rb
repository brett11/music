class Venue < ApplicationRecord
  belongs_to :city
  has_many :concerts
end

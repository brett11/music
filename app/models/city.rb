class City < ApplicationRecord
  belongs_to :state
  belongs_to :country
  has_many :venues
end

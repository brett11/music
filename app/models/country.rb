class Country < ApplicationRecord
  has_many :cities
  validates :name, presence: true, length: { maximum: 45 }
end

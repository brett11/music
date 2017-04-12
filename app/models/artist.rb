class Artist < ApplicationRecord
  has_and_belongs_to_many :concerts
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :users
end

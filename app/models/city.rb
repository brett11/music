class City < ApplicationRecord
  belongs_to :state
  belongs_to :country
  has_many :venues
  validates :name, presence: true, length: { maximum: 45 }
  validates :country_id, presence: true

  #see full_city_name(city) in application_helper.rb
  def full_name
    if self.country.name == "USA" && self.name != "Washington DC"
      city_name = self.name + ", " + self.state.abbreviation + ", " + self.country.name
    else
      city_name = self.name + ", " + self.country.name
    end
  end

end

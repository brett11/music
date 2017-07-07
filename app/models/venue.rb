class Venue < ApplicationRecord
  belongs_to :city
  validates :city_id, presence: true
  has_many :concerts
  validates :name, presence: true, length: { maximum: 60 }

  def self.new_from_controller(params)
    new(params)
  end

  # http://railscasts.com/episodes/343-full-text-search-in-postgresql?view=asciicast
  include PgSearch
  pg_search_scope :text_search, against: :name,
                  associated_against: { city: :name,
                  },
                  using: {tsearch: { prefix: true } },
                  ignoring: :accents


  def self.search(entry)
    if entry.present?
      text_search(entry)
      # superseded
      # self.where('name ILIKE ?', "%#{entry}%")
    else
      # https://stackoverflow.com/questions/18198963/with-rails-4-model-scoped-is-deprecated-but-model-all-cant-replace-it
      self.where(nil)
    end
  end
end

class Concert < ApplicationRecord
  belongs_to :venue
  validates :venue_id, presence: true
  has_one :city, through: :venue
  has_and_belongs_to_many :artists
  validates :artist_ids, presence: true
  validates :dateandtime, presence: true

  # http://railscasts.com/episodes/343-full-text-search-in-postgresql?view=asciicast
  include PgSearch
  pg_search_scope :text_search, against: :dateandtime,
                  associated_against: { artists: :name_stage,
                                        venue: :name,
                                        city: :name
                                      },
                  using: {tsearch: { prefix: true } },
                  ignoring: :accents

  def self.new_from_controller(params)
    new(params)
  end

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

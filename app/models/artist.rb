class Artist < ApplicationRecord
  has_and_belongs_to_many :concerts
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :users
  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '256x256>'
  }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates :name_first, length: { maximum: 45 }
  validates :name_last, length: { maximum: 45 }
  validates :name_stage, presence: true, length: { maximum: 45 }

  # http://railscasts.com/episodes/343-full-text-search-in-postgresql?view=asciicast
  include PgSearch
  pg_search_scope :text_search, against: :name_stage,
                  using: {tsearch: { prefix: true } },
                  ignoring: :accents


  def self.search(entry)
    if entry.present?
      text_search(entry)
      # superseded
      # self.where('name_stage ILIKE ?', "%#{entry}%")
    else
      # https://stackoverflow.com/questions/18198963/with-rails-4-model-scoped-is-deprecated-but-model-all-cant-replace-it
      self.where(nil)
    end
  end
end

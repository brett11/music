class Album < ApplicationRecord
  has_and_belongs_to_many :artists
  has_many :songs
  has_attached_file :album_cover, styles: {
    thumb: '100x100>',
    square: '200x200',
    medium: '300x300>'
  }
  validates_attachment_content_type :album_cover, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :name, presence: true, length: { maximum: 100 }
  validates :release_date, presence: true
  validates :artists, presence: true

  def self.search(entry)
    if entry
      self.where('name ILIKE ?', "%#{entry}%")
    else
      # https://stackoverflow.com/questions/18198963/with-rails-4-model-scoped-is-deprecated-but-model-all-cant-replace-it
      self.where(nil)
    end
  end
end

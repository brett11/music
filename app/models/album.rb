class Album < ApplicationRecord
  has_and_belongs_to_many :artists
  has_many :songs
  has_attached_file :album_cover, styles: {
    thumb: '100x100>',
    square: '200x200',
    medium: '300x300>'
  }
  validates_attachment_content_type :album_cover, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end

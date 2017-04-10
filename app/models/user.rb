class User < ApplicationRecord
  before_save {self.email = email.downcase}
  before_save {self.name_first = name_first.titlecase}
  before_save {self.name_last = name_last.titlecase}
  has_secure_password
  validates :name_first, presence: true, length: { maximum: 50 }
  validates :name_last, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }, allow_nil: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 240 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
end

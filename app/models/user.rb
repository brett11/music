class User < ApplicationRecord
  has_many :fanships, dependent: :destroy
  has_many :following, through: :fanships, source: :artist
  before_save :downcase_email
  before_save :titlecase_names
  before_create :create_activation_digest
  has_attached_file :profile_pic, styles: {
    thumb: '100x100>',
    square: '200x200',
    medium: '300x300>'
  }, default_url: "/system/missing/:style/missing.png"

  validates_attachment_content_type :profile_pic, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_secure_password
  validates :name_first, presence: true, length: { maximum: 45 }
  validates :name_last, presence: true, length: { maximum: 45 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }, allow_nil: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 240 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  attr_accessor :activation_token, :remember_token, :reset_token

  #Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    #update_attribute updates the database
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Activates an account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    #update_attribute updates the database. we can't use here because user not yet saved in database
    self.activation_digest = User.digest(activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    #update_attribute updates the database. we can't use here because user not yet saved in database
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #Sends password reset email.
  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #two below methods are in this section because they are callbacks called during particular time during user object's life
  def downcase_email
    self.email = email.downcase
  end

  def titlecase_names
    self.name_first = name_first.downcase.capitalize
    self.name_last = name_last.downcase.capitalize
  end

  # forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def follow(artist)
    following << artist
  end

  def unfollow(artist)
    following.delete(artist)
  end

  def following?(artist)
    following.include?(artist)
  end
end

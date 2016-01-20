class User < ActiveRecord::Base
  attr_accessor :remember_token

  has_many :rooms
  has_many :reservations

  before_save { self.email = email.downcase }

  validates :name, 
            presence: true,
            length: { maximum: 20, minimum: 3 },
            uniqueness: { case_sensitive: false }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
            presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  after_initialize :default
  def default
    self.state  ||= 'Free'
  end

  def upgrade
    if self.state == 'Free'
      self.state = 'Host'
      return true
    else
      return false
    end
  end

  def new_room(name)
    if state == 'Host'
      rooms.create(:name => name)
      return true
    else
      return false
    end
  end

  def reserve_room(room_id, from, to)
    if Room.find(room_id).reserved?(from, to)
      return false
    else
      Reservation.create(user_id: id, room_id: room_id, from: from.to_date, to: to.to_date)
    end
  end
end

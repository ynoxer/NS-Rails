class User < ActiveRecord::Base
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

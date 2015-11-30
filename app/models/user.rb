class User < ActiveRecord::Base
  has_many :rooms

  validates :name, presence: true, length: { maximum: 20, minimum: 3 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  after_initialize :default
  def default
    self.type  ||= 'Free'
  end

  def upgrade
    if self.type == 'Free'
      self.type = 'Host'
      return true
    else
      return false
    end
  end

  def new_room(name)
    if self.type == 'Host'
      self.rooms.create(:name => name)
      return true
    else
      return false
    end
  end
end

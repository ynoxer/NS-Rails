class Room < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  validates :name, presence: true, length: { maximum: 40, minimum: 3 }

  def publishable?
    if (state == 'Draft') && (self.valid?) &&
       (address.present?) && (price.present?)
      return true
    else
      return false
    end
  end

  def publish
    if publishable?
      update_attribute(:state, 'Published')
      update_attribute(:expiration, Time.now + (60 * 60 * 24 * 30))
      return true
    else
      return false
    end
  end

  def revoke
    if state == 'Published'
      update_attribute(:state, 'Revoked')
      return true
    else
      return false
    end
  end

  def expire
    if (state == 'Published') && (Time.now > expiration)
      revoke
      return true
    else
      return false
    end
  end

  def edit_room(options = {})
    self.name = options[:name] || name
    self.address = options[:address] || address
    self.price = options[:price] || price
    save
  end

  def reserved?(from, to)
    a = (from.to_date..to.to_date)
    reserved = false
    Reservation.where(room_id: id).find_each do |reservation|
      if a.include?(reservation.from) || a.include?(reservation.to)
        reserved = true
      end
    end
    reserved
  end
end

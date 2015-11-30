class Room < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, length: { maximum: 40, minimum: 3 }

  def publishable?
    if (self.type == 'Draft') && (self.valid?) &&
       (self.address.present?) && (self.price.present?)
      return true
    else
      return false
    end
  end

  def publish
    if publishable?
      update_attribute(:type, 'Published')
      update_attribute(:expiration, Time.now + (60 * 60 * 24 * 30))
      return true
    else
      return false
    end
  end

  def revoke
    if type == 'Published'
      update_attribute(:type, 'Revoked')
      return true
    else
      return false
    end
  end

  def expire
    if (type == 'Published') && (Time.now > expiration)
      revoke
      return true
    else
      return false
    end
  end

  def edit_room(options = {})
    self.name = options[:name] || self.name
    self.address = options[:address] || self.address
    self.price = options[:price] || self.price
    self.save
  end
end

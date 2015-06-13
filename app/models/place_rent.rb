class PlaceRent < ActiveRecord::Base
  belongs_to :parking
  belongs_to :car
  validates  :starts_at, :ends_at, :parking, :car, presence: true
  validates  :identifier, presence: true, uniqueness: true

  before_validation :auto_generated, on: :create
  before_save :set_price

  def calculate_price
    difference = (ends_at - starts_at)
    days = (difference / 1.day).to_i
    difference -= days * 1.day
    hours = (difference / 1.hour).ceil
    parking.day_price * days + parking.hour_price * hours
  end

  def finish
    if ends_at > Time.now
      self.update_attributes(ends_at: Time.now)
    end
  end

  def to_param
    self.identifier
  end

  private

  def set_price
    self.price = calculate_price
  end

  def auto_generated
    self.identifier = SecureRandom.hex
  end
end

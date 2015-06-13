class Parking < ActiveRecord::Base

  Kinds = [I18n.t(:outdoor, scope: ['activerecord.parking']), I18n.t(:indoor, scope: ['activerecord.parking']), I18n.t(:private, scope: ['activerecord.parking']), I18n.t(:street, scope: ['activerecord.parking'])]

  belongs_to :address
  belongs_to :owner, class_name: 'Person'

  has_many   :place_rents

  validates  :places, :hour_price, :day_price, presence: true
  validates  :kind, inclusion: { in: Kinds}
  validates  :hour_price, :day_price,  numericality: { greater_than_or_equal_to: 0 }

  after_destroy :set_new_ends_at

  accepts_nested_attributes_for :address

  scope :public_parkings, -> { where(kind: ["outdoor", "indoor", "street"]) }
  scope :private_parkings, -> { where(kind: "private") }
  scope :day_price_parkings, -> (min_price, max_price) { where(day_price: min_price..max_price) }
  scope :hour_price_parkings, -> (min_price, max_price) { where(hour_price: min_price..max_price) }
  scope :given_city_parkings, -> (city) { joins(:address).where(addresses: { city: city }) }

  def self.search(parking_data)
    parkings = Parking.all
    parkings = parkings.given_city_parkings(parking_data[:city]) if parking_data[:city].present?
    parkings = parkings.day_price_parkings(parking_data[:day_price_from], parking_data[:day_price_to]) if parking_data[:day_price_from].present? && parking_data[:day_price_to].present?
    parkings = parkings.hour_price_parkings(parking_data[:hour_price_from], parking_data[:hour_price_to]) if parking_data[:hour_price_from].present? && parking_data[:hour_price_to].present?
    parkings = parkings.public_parkings if parking_data[:public].present?
    parkings = parkings.private_parkings if parking_data[:private].present?
    parkings
  end

  private

  def set_new_ends_at
    self.place_rents.each { |p| p.finish }
  end
end

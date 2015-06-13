require 'test_helper'

class ParkingTest < ActiveSupport::TestCase

  setup do
    @parking = parkings(:parking1)
    @place_rent = place_rents(:first_place_rent)
  end

  test "should be invalid without places" do
    @parking.places = nil
    @parking.valid?
    assert @parking.errors.keys.include? :places
  end

  test "should be invalid without hour_price" do
    @parking.hour_price = nil
    @parking.valid?
    assert @parking.errors.keys.include? :hour_price
  end

  test "should be invalid without day_price" do
    @parking.day_price = nil
    @parking.valid?
    assert @parking.errors.keys.include? :day_price
  end

  test "should be invalid with hour_price less than 0" do
    @parking.hour_price = -5
    @parking.valid?
    assert @parking.errors.keys.include? :hour_price
  end

  test "should be invalid with day_price less than 0" do
    @parking.day_price = -5
    @parking.valid?
    assert @parking.errors.keys.include? :day_price
  end

  test "should be invalid with wrong kind" do
    @parking.kind = "whatever"
    @parking.valid?
    assert @parking.errors.keys.include? :kind
  end

  test "public_parkings should return parkings with correct kind" do
    assert_equal [parkings(:parking1), parkings(:parking3)].sort, Parking.public_parkings.sort
  end

  test "private_parkings should return parkings with correct kind" do
    assert_equal [parkings(:parking2)], Parking.private_parkings
  end

  test "price_parkings should return parkings with correct day price" do
    assert_equal [parkings(:parking2), parkings(:parking3)].sort, Parking.day_price_parkings(15, 21).sort
  end

  test "hour_price_parkings should return parkings with correct hour price" do
    assert_equal [parkings(:parking1), parkings(:parking3)].sort, Parking.hour_price_parkings(1, 2).sort
  end

  test "self.given_city_parkings should return parkings with correct city" do
    assert_equal [parkings(:parking1)], Parking.given_city_parkings("city1")
  end

  test "destroying a parking finishes rentals" do
    @parking.destroy
    assert_equal Time.now.day, @place_rent.reload.ends_at.day
 end
end

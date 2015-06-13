require 'test_helper'

class PlaceRentTest < ActiveSupport::TestCase

  setup do
    @place_rent = place_rents(:first_place_rent)
    @place_rent2 = place_rents(:second_place_rent)
  end

  test "should be invalid without starts_at" do
    @place_rent.starts_at = nil
    @place_rent.valid?
    assert @place_rent.errors.keys.include? :starts_at
  end

  test "should be invalid without ends_at" do
    @place_rent.ends_at = nil
    @place_rent.valid?
    assert @place_rent.errors.keys.include? :ends_at
  end

  test "should be invalid without parking" do
    @place_rent.parking = nil
    @place_rent.valid?
    assert @place_rent.errors.keys.include? :parking
  end

  test "should be invalid without car" do
    @place_rent.car = nil
    @place_rent.valid?
    assert @place_rent.errors.keys.include? :car
  end

  test "should be valid with correct data" do
    @place_rent.valid?
    assert_equal 8812.0, @place_rent.calculate_price.to_f
    assert_equal 15.0, @place_rent2.calculate_price.to_f
  end
end

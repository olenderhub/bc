require 'test_helper'

class CarTest < ActiveSupport::TestCase

  setup do
    @car = cars(:one)
  end

  test "should be invalid without owner" do
    @car.owner = nil
    @car.valid?
    assert @car.errors.keys.include? :owner
  end

  test "should be invalid without registration_number" do
    @car.registration_number = nil
    @car.valid?
    assert @car.errors.keys.include? :registration_number
  end

  test "should be invalid without model" do
    @car.model = nil
    @car.valid?
    assert @car.errors.keys.include? :model
  end

  test "should be valid with owner, registration_number, model" do
    assert @car.valid?
  end
end

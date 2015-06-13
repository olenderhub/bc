require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  test "should be invalid without city, street, zip_code" do
    address = Address.new(city: "", street: "", zip_code: "ok")
    address.valid?
    assert_equal [:city, :street, :zip_code], address.errors.keys
  end

  test "should be valid with correct data" do
  	address = addresses(:address_one)
    assert address.valid?
  end
end

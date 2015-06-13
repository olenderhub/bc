require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    @person = people(:person1)
  end

  test "should be invalid without first_name" do
    @person.first_name = nil
    @person.valid?
    assert @person.errors.keys.include? :first_name
  end

  test "should be valid with correct data" do
    assert @person.valid?
  end
end

require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "authenticate when email and password is correct" do
    assert_equal Account.where(email: "test1@test.pl"), [Account.authenticate("test1@test.pl", "test1")]
  end

  test "authenticate when only password is correct" do
    assert_equal nil, Account.authenticate("testfalse@test.pl", "test1")
  end

  test "authenticate when only email is correct" do
    assert_equal false, Account.authenticate("test1@test.pl", "testfalse")
  end
end




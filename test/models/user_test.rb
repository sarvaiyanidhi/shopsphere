require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user with valid email should be valid" do
    user = User.new(email: "test@test.org", password_digest: "test")
    assert user.valid?
  end

  test "user with invalid email should not be valid" do
    user = User.new(email: "test", password_digest: "test")
    assert_not user.valid?
  end

  test "user with taken email should be invalid" do
    user = users(:one)
    other_user = User.new(email: user.email, password_digest: "password")
    assert_not other_user.valid?
  end
end

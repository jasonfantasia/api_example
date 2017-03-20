require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.first
    @user2 = User.second
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should be 255 characters or less" do
    @user.name = "x" * 256
    assert_not @user.valid?
  end

  test "email should be 255 characters or less" do
    @user.email = "x" * 256
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should be unique" do
    @user2.email = @user.email
    assert_not @user2.valid?
  end

  test "auth token should be unique" do
    @user2.auth_token = @user.auth_token
    assert_not @user2.valid?
  end

  test "generate_auth_token should create new token" do
    current_token = @user.auth_token
    @user.generate_auth_token
    assert_not_equal(current_token, @user.auth_token)
  end

  test "generate_auth_token should return same value as attribute" do
    current_token = @user.auth_token
    new_token = @user.generate_auth_token
    assert_equal(@user.auth_token, new_token)
  end

  test "revoke_auth_token should remove attribute value" do
    @user.generate_auth_token if @user.auth_token.blank?
    if @user.auth_token
      @user.revoke_auth_token
      assert_nil @user.auth_token
    else
      flunk "generate_auth_token doesnt generate tokens? ¯\_(ツ)_/¯"
    end
  end
end

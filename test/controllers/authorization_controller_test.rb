require 'test_helper'

class AuthorizationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = "abc123"
    @user = users(:one)
    @user.update(password: @password, password_confirmation: @password)
  end

  test "sign_up should create user" do
    assert_difference("User.count") do
      post sign_up_url,
        params: {
          user: {
            name: "New User",
            email: "new_user@domain.org",
            password: "abc123",
            password_confirmation: "abc123"
          }
        },
        as: :json
    end
  end

  test "successful authentication generates a token" do
    post generate_token_url,
      params: { email: @user.email, password: @password },
      as: :json

    assert JSON.parse(@response.body)["auth_token"].present?
    assert_response :ok
  end

  test "unsuccessful authentication receives unauthorized response" do
    post generate_token_url,
      params: { email: @user.email, password: "oops" },
      as: :json

    assert_not JSON.parse(@response.body)["auth_token"].present?
    assert_response :unauthorized
  end

  test "authorized revoke deletes auth token" do
    delete revoke_token_url,
      headers: { "HTTP_AUTHORIZATION" => "Token token=#{@user.auth_token}" },
      as: :json

    @user.reload
    assert_nil @user.auth_token
    assert_response :ok
  end

  test "unauthorized revoke receives unauthorized response" do
    delete revoke_token_url,
      headers: { "HTTP_AUTHORIZATION" => "Token token=secrets_tokenz" },
      as: :json

    assert_response :unauthorized
  end
end

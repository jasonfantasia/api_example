require 'test_helper'

class WidgetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @widget = widgets(:one)
    @user = users(:one)
    @user.generate_auth_token
    @auth_header = { "HTTP_AUTHORIZATION" => "Token token=#{@user.auth_token}" }
  end

  test "authorized user should get index" do
    get widgets_url, headers: @auth_header, as: :json
    assert_response :success
  end

  test "unauthorized get should not get index" do
    get widgets_url, as: :json
    assert_response :unauthorized
  end

  test "authorized user should create widget" do
    assert_difference('Widget.count') do
      post widgets_url,
        params: { widget: { name: @widget.name } },
        headers: @auth_header,
        as: :json
    end

    assert_response 201
  end

  test "unauthorized user should not create widget" do
    post widgets_url,
      params: { widget: { name: @widget.name } },
      as: :json

    assert_response :unauthorized
  end

  test "authorized user should show widget" do
    get widget_url(@widget), headers: @auth_header, as: :json
    assert_response :success
  end

  test "unauthorized user should not show widget" do
    get widget_url(@widget), as: :json
    assert_response :unauthorized
  end
  
  test "authorized user should update widget" do
    patch widget_url(@widget),
      params: { widget: { name: @widget.name } },
      headers: @auth_header,
      as: :json
    assert_response 200
  end

  test "unauthorized user should not update widget" do
    patch widget_url(@widget),
      params: { widget: { name: @widget.name } },
      as: :json
    assert_response :unauthorized
  end

  test "authorized user should destroy widget" do
    assert_difference('Widget.count', -1) do
      delete widget_url(@widget), headers: @auth_header, as: :json
    end
    assert_response 204
  end

  test "unauthorized user should not destroy widget" do
    delete widget_url(@widget), as: :json
    assert_response :unauthorized
  end
end

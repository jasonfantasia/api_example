class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_request

  def current_user
    @current_user ||= find_user_by_token
  end

  def render_not_authorized
    render json: { error: "Not Authorized" }, status: :unauthorized
  end

  private

  def authenticate_request
    return true if find_user_by_token
    render_not_authorized
  end

  def find_user_by_token
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end
  end
end

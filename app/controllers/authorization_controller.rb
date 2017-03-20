class AuthorizationController < ApplicationController
  skip_before_action :authenticate_request, only: [:sign_up, :generate_token]

  # POST /sign_up
  def sign_up
    user = User.new(user_params)

    if user.save
      message = "Account created." +
        "  Request authorization token at: #{generate_token_url}"

      render json: { message: message }, status: :created
    else
      message = "Could not create user"
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def generate_token
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      auth_token = user.generate_auth_token
      render json: { auth_token: auth_token }, status: :ok
    else
      render_not_authorized
    end
  end

  def revoke_token
    current_user.revoke_auth_token
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # TODO: CORS
  # https://dev.to/mohhossain/a-complete-guide-to-rails-authentication-using-jwt-403p

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end

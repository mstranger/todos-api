class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  resource_description do
    short "Users sing in"
  end

  api! "User login"
  param :email, String, required: true
  param :password, String, required: true
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

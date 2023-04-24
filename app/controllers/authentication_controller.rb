class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  resource_description do
    short "Users sing in"
    error 401, "Invalid credentials"
  end

  api! "User login"
  param :email, String, required: true
  param :password, String, required: true
  returns code: 200, desc: "a successful login" do
    property :token, String, desc: "json web token"
  end
  #
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: t("user.errors.auth_fail") }, status: :unauthorized
    end
  end
end

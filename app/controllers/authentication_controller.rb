class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  resource_description do
    short "User sign in"
    error 401, "Invalid credentials"
  end

  api! "User login"
  param :email, String, required: true
  param :password, String, required: true
  returns code: 200, desc: "Successful login" do
    property :token, String, desc: "json web token"
  end
  #
  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id, email: @user.email)
      render json: {token: token}, status: :ok
    else
      render json: {error: t("user.errors.auth_fail")}, status: :unauthorized
    end
  end
end

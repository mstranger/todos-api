class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  resource_description do
    short "Users sign up"
  end

  def_param_group :user_data do
    param :email, String, required: true
    param :password, String, required: true
  end

  def_param_group :jwt_info do
    description "Need to use jwt token for authentication"
    example "'Authorization' => 'HS256 foo.bar.token'"
  end

  api! "New user registration"
  param_group :user_data
  #
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  api :PUT, "/users", "Update user info"
  api :PATCH, "/users", "Update user info"
  param_group :user_data
  param_group :jwt_info
  #
  def update
    if @current_user.update(user_params)
      render json: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  end

  api! "Current user info"
  param_group :jwt_info
  #
  def me
    render json: @current_user
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end

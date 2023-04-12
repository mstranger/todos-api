class UsersController < ApplicationController
  resource_description do
    short "Users sign up"
  end

  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  api! "New user registration"
  param :email, String, required: true
  param :password, String, required: true
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def destroy
    @user.destroy
  end

  # TODO: apipie jwt auth info

  api! "Current user info"
  def me
    render json: @current_user
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

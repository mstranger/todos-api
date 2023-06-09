class ApplicationController < ActionController::API
  include JsonWebToken

  rescue_from JWT::DecodeError, with: :unauthorized
  rescue_from Apipie::ParamError, with: :invalid_param

  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split&.last
    decoded = jwt_decode(token)
    @current_user = User.find_by(id: decoded[:user_id])
  end

  def unauthorized
    render json: {error: t("user.errors.login_first")}, status: :unauthorized
  end

  def invalid_param(exception)
    render json: {error: exception.message}, status: :unprocessable_entity
  end

  def t(msg, **args)
    I18n.t(msg, **args)
  end
end

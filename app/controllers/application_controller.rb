class ApplicationController < ActionController::API
  include JsonWebToken

  rescue_from JWT::DecodeError, with: :unauthorized

  before_action :authenticate_request

  private

  def authenticate_request
    # debugger
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_user = User.find_by(id: decoded[:user_id])
  end

  def unauthorized
    render json: { error: "Please, sign in first" }, status: :unauthorized
  end
end

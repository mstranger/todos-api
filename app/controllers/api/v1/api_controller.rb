class Api::V1::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_invalid(exception)
    render json: {errors: exception.record.errors.messages.map { |_k, v| v }.flatten},
           status: :unprocessable_entity
  end

  def record_not_found(exception)
    render json: {error: exception.message}, status: :not_found
  end
end

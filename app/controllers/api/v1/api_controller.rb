class Api::V1::ApiController < ActionController::API
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound,     with: :not_found
  rescue_from ActiveRecord::RecordInvalid,      with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotDestroyed, with: :unprocessable_entity

  private

  def not_found
    head 404
  end

  def unprocessable_entity
    head 422
  end
end

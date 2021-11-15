module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { errors: e.record.errors }, status: :unprocessable_entity
    end
  end
end
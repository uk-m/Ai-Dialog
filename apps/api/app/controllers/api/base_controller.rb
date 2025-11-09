module Api
  class BaseController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Devise::Controllers::Helpers
    include ActionController::MimeResponds

    before_action :authenticate_user!
    before_action :ensure_json_format

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity

    private

    def render_not_found(error)
      render json: { error: error.message }, status: :not_found
    end

    def render_unprocessable_entity(error)
      render json: { error: error.message }, status: :unprocessable_entity
    end

    def pagination_meta(collection)
      {
        total: collection.total_count,
        per_page: collection.limit_value,
        page: collection.current_page,
        total_pages: collection.total_pages
      }
    end

    def ensure_json_format
      request.format = :json
    end
  end
end

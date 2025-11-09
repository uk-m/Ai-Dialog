module Api
  module V1
    class PreferencesController < BaseController
      def show
        render json: current_user.preferences
      end

      def update
        current_user.update!(preferences_params)
        render json: current_user.preferences
      end

      private

      def preferences_params
        params.require(:preferences).permit(:theme, :language, :week_start)
      end
    end
  end
end

module Api
  module V1
    class WeeklyDigestsController < BaseController
      def index
        per_page = params.fetch(:per, 5).to_i.clamp(1, 20)
        digests = current_user.weekly_digests.recent.page(params[:page]).per(per_page)
        render json: { data: digests.map { |digest| serialize(digest) }, meta: pagination_meta(digests) }
      end

      def show
        digest = current_user.weekly_digests.find(params[:id])
        render json: serialize(digest)
      end

      def generate
        week = params[:week_of].present? ? Date.parse(params[:week_of]) : Date.current
        WeeklyDigestJob.perform_later(current_user.id, week.beginning_of_week)
        head :accepted
      rescue ArgumentError
        render json: { error: "week_of の形式が不正です" }, status: :unprocessable_entity
      end

      private

      def serialize(digest)
        {
          id: digest.id,
          week_of: digest.week_of,
          summary: digest.summary,
          highlights: digest.highlights,
          mood_trends: digest.mood_trends,
          published_at: digest.published_at
        }
      end
    end
  end
end

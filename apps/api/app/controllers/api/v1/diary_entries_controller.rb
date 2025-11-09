module Api
  module V1
    class DiaryEntriesController < BaseController
      before_action :set_entry, only: %i[show update destroy publish regenerate]

      def index
        per_page = params.fetch(:per, 10).to_i.clamp(1, 50)
        entries = current_user.diary_entries.includes(:tags, photos_attachments: :blob).recent.page(params[:page]).per(per_page)
        render json: { data: entries.map { |entry| DiaryEntrySerializer.new(entry).as_json }, meta: pagination_meta(entries) }
      end

      def show
        render json: DiaryEntrySerializer.new(@entry).as_json
      end

      def create
        entry = current_user.diary_entries.new(entry_params)
        if entry.save
          attach_photos(entry)
          enqueue_ingestion(entry)
          render json: DiaryEntrySerializer.new(entry).as_json, status: :created
        else
          render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @entry.update(entry_params)
          attach_photos(@entry)
          render json: DiaryEntrySerializer.new(@entry).as_json
        else
          render json: { errors: @entry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @entry.destroy
        head :no_content
      end

      def publish
        @entry.publish!
        render json: DiaryEntrySerializer.new(@entry).as_json
      end

      def regenerate
        DiaryDraftJob.perform_later(@entry.id)
        head :accepted
      end

      def calendar
        data = current_user.diary_entries.group(:journal_date).count.map do |date, count|
          { date:, count: }
        end

        render json: data
      end

      def timeline
        entries = current_user.diary_entries.published.recent.limit(20)
        render json: entries.map { |entry| DiaryEntrySerializer.new(entry).as_json }
      end

      private

      def set_entry
        @entry = current_user.diary_entries.find(params[:id])
      end

      def entry_params
        params.require(:diary_entry).permit(:title, :body, :journal_date, :mood, :status, tag_names: [])
      end

      def attach_photos(entry)
        return unless params[:photos].present?

        Array.wrap(params[:photos]).each { |photo| entry.photos.attach(photo) }
      end

      def enqueue_ingestion(entry)
        entry.photos.each do |photo|
          DiaryIngestionJob.perform_later(entry.id, photo.blob_id)
        end
      end
    end
  end
end

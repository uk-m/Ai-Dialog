module Api
  module V1
    class UploadsController < BaseController
      def create
        entry = current_user.diary_entries.create!(
          title: params[:title].presence || "新しい日記",
          journal_date: params[:journal_date].presence || Date.current,
          status: :draft
        )

        entry.photos.attach(params.require(:photo))
        DiaryIngestionJob.perform_later(entry.id, entry.photos.last.blob_id)

        render json: DiaryEntrySerializer.new(entry).as_json, status: :created
      end
    end
  end
end

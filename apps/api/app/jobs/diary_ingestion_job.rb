class DiaryIngestionJob < ApplicationJob
  queue_as :ingestion

  def perform(entry_id, blob_id)
    entry = DiaryEntry.find(entry_id)
    blob = ActiveStorage::Blob.find(blob_id)

    analysis = ImageAnalyzer.new(blob).call

    entry.metadata = entry.metadata.merge(analysis.fetch(:metadata, {}))
    entry.extracted_text = analysis[:ocr_text]
    entry.labels = analysis[:labels] || []
    entry.save!

    DiaryDraftJob.perform_later(entry.id, analysis)
  end
end

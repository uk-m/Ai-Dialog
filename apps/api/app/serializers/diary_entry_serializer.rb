class DiaryEntrySerializer
  include Rails.application.routes.url_helpers

  def initialize(entry)
    @entry = entry
  end

  def as_json(*)
    {
      id: entry.id,
      title: entry.title,
      body: entry.body,
      ai_summary: entry.ai_summary,
      mood: entry.mood,
      status: entry.status,
      journal_date: entry.journal_date,
      published_at: entry.published_at,
      labels: entry.labels,
      metadata: entry.metadata,
      extracted_text: entry.extracted_text,
      tags: entry.tag_names,
      photos: photo_payload,
      created_at: entry.created_at,
      updated_at: entry.updated_at
    }
  end

  private

  attr_reader :entry

  def photo_payload
    entry.photos.map do |photo|
      {
        id: photo.id,
        filename: photo.filename.to_s,
        byte_size: photo.byte_size,
        content_type: photo.content_type,
        url: blob_url(photo)
      }
    end
  end

  def blob_url(photo)
    rails_blob_path(photo, only_path: true)
  rescue StandardError
    nil
  end
end

class DiaryDraftJob < ApplicationJob
  queue_as :drafting

  def perform(entry_id, analysis_payload = {})
    entry = DiaryEntry.find(entry_id)

    draft = OpenAiDiaryDraftService.new(user: entry.user, entry: entry, analysis_payload: analysis_payload).call

    entry.title = draft[:title] if draft[:title].present?
    entry.body = draft[:body] if draft[:body].present?
    entry.mood = draft[:mood] if draft[:mood].present?
    entry.ai_summary = draft[:summary]
    entry.tag_names = draft[:tags] if draft[:tags]
    entry.save!
  end
end

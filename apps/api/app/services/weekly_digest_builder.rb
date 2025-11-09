class WeeklyDigestBuilder
  def initialize(user:, range:)
    @user = user
    @range = range
  end

  def call
    entries = user.diary_entries.published.where(journal_date: range).order(:journal_date)
    {
      summary: build_summary(entries),
      highlights: build_highlights(entries),
      mood_trends: build_mood_trends(entries)
    }
  end

  private

  attr_reader :user, :range

  def build_summary(entries)
    return "今週はまだ公開済みの投稿がありません。" if entries.blank?

    return ai_summary(entries) if ENV["OPENAI_API_KEY"].present?

    <<~TEXT.squish
      #{user.display_name}さんの1週間: #{entries.size}件の投稿がありました。
      最も新しい投稿は#{entries.last.journal_date.strftime("%-m/%-d")}の「#{entries.last.title}」です。
    TEXT
  end

  def ai_summary(entries)
    prompt = entries.map { |entry| "#{entry.journal_date}: #{entry.title} / #{entry.mood}" }.join("\n")
    response = OpenAI::Client.new.chat(
      parameters: {
        model: Rails.configuration.x.openai_model,
        temperature: 0.3,
        messages: [
          { role: "system", content: "あなたは一週間の日記を要約する編集者です。日本語で丁寧に一段落にまとめてください。" },
          { role: "user", content: prompt }
        ]
      }
    )
    response.dig("choices", 0, "message", "content") || "今週のまとめを生成できませんでした。"
  rescue StandardError
    "今週のまとめを生成できませんでした。"
  end

  def build_highlights(entries)
    entries.map do |entry|
      {
        title: entry.title,
        date: entry.journal_date,
        mood: entry.mood,
        tags: entry.tag_names
      }
    end
  end

  def build_mood_trends(entries)
    entries.group_by(&:mood).transform_values(&:count)
  end
end

class OpenAiDiaryDraftService
  def initialize(user:, entry:, analysis_payload: {})
    @user = user
    @entry = entry
    @analysis_payload = analysis_payload
  end

  def call
    return fallback_payload if ENV["OPENAI_API_KEY"].blank?

    response = client.chat(
      parameters: {
        model: Rails.configuration.x.openai_model,
        temperature: 0.4,
        response_format: { type: "json_schema", json_schema: response_schema },
        messages: [
          {
            role: "system",
            content: <<~PROMPT
              あなたは画像とメタデータから写真日記の下書きを作るアシスタントです。
              出力は必ず JSON schema に沿ってください。
            PROMPT
          },
          { role: "user", content: prompt }
        ]
      }
    )

    body = response.dig("choices", 0, "message", "content")
    JSON.parse(body, symbolize_names: true)
  rescue JSON::ParserError, OpenAI::Error, Errno::ECONNREFUSED
    fallback_payload
  end

  private

  attr_reader :user, :entry, :analysis_payload

  def prompt
    <<~PROMPT
      User: #{user.display_name}
      Date: #{entry.journal_date}
      Existing title: #{entry.title}
      Extracted text: #{analysis_payload[:ocr_text]}
      Labels: #{analysis_payload[:labels]&.join(", ")}
      Metadata: #{analysis_payload[:metadata]}

      写真の雰囲気や気温、感情を推測して日記の下書きを作成してください。
    PROMPT
  end

  def fallback_payload
    label_text = analysis_payload[:labels].presence&.join(", ")
    meta_text = analysis_payload[:metadata].presence || {}
    camera_hint = meta_text[:camera] ? "（#{meta_text[:camera]} で撮影）" : ""
    ocr_hint = analysis_payload[:ocr_text].present? ? "写真に写った文字として「#{analysis_payload[:ocr_text]}」を確認しました。" : ""

    safe_body = <<~BODY.squish
      今日は気ままにカメラを持って過ごしました。#{label_text ? "「#{label_text}」のような印象の一枚です。" : ""}
      #{ocr_hint}#{camera_hint}
    BODY

    {
      title: entry.title.presence || "今日の思い出",
      body: entry.body.presence || safe_body,
      mood: "neutral",
      summary: "画像の雰囲気から穏やかな一日を振り返りました。",
      tags: analysis_payload[:labels].presence || ["draft"]
    }
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def response_schema
    {
      name: "diary_entry",
      schema: {
        type: "object",
        properties: {
          title: { type: "string" },
          body: { type: "string" },
          mood: { type: "string" },
          summary: { type: "string" },
          tags: { type: "array", items: { type: "string" } }
        },
        required: %w[title body mood summary tags],
        additionalProperties: false
      },
      strict: true
    }
  end
end

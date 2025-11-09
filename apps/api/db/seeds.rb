user = User.find_or_initialize_by(email: "demo@aidia.local")
user.assign_attributes(
  password: "password12345!",
  password_confirmation: "password12345!",
  name: "AiDia Demo",
  confirmed_at: Time.current
)
user.skip_confirmation!
user.save!

%w[旅行 料理 自然 ペット 家族].each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end

entry = user.diary_entries.find_or_create_by!(journal_date: Date.current) do |diary|
  diary.title = "サンプル日記"
  diary.body = "画像をアップロードすると、ここにAIが生成した本文が入ります。"
  diary.mood = "calm"
  diary.status = :published
  diary.published_at = Time.current
  diary.labels = ["demo"]
end

entry.tag_names = %w[旅行 demo]
entry.save!

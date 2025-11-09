class WeeklyDigestJob < ApplicationJob
  queue_as :digests

  def perform(user_id, week_of = Date.current.beginning_of_week(:monday))
    user = User.find(user_id)
    week_start = week_of.to_date.beginning_of_week(:monday)
    range = week_start..week_start.end_of_week(:monday)

    digest = WeeklyDigestBuilder.new(user:, range:).call

    WeeklyDigest.upsert(
      {
        user_id: user.id,
        week_of: week_start,
        summary: digest[:summary],
        highlights: digest[:highlights],
        mood_trends: digest[:mood_trends],
        published_at: Time.current,
        created_at: Time.current,
        updated_at: Time.current
      },
      unique_by: %i[user_id week_of]
    )
  end
end

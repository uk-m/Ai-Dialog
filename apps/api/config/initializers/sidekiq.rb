redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  if defined?(Sidekiq::Cron)
    schedule = {
      "weekly_digest_job" => {
        "cron" => ENV.fetch("WEEKLY_DIGEST_CRON", "0 9 * * MON"),
        "class" => "WeeklyDigestJob"
      }
    }

    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

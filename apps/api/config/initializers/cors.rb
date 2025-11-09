Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    allowlist = ENV.fetch("CORS_ORIGINS", "http://localhost:5173")
    origins(*allowlist.split(","))

    resource "*",
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post put patch delete options head]
  end
end

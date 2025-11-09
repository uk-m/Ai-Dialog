Devise.setup do |config|
  config.mailer_sender = ENV.fetch("DEVISE_MAILER_SENDER", "no-reply@aidia.local")
  require "devise/orm/active_record"

  config.case_insensitive_keys = %i[email]
  config.strip_whitespace_keys = %i[email]
  config.skip_session_storage = %i[http_auth params_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.password_length = 12..128
  config.timeout_in = 2.weeks
  config.reset_password_within = 6.hours
  config.navigational_formats = []
  config.sign_out_via = :delete

  config.secret_key = ENV["DEVISE_SECRET_KEY"] if ENV["DEVISE_SECRET_KEY"].present?
end

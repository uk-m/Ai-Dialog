DeviseTokenAuth.setup do |config|
  config.change_headers_on_each_request = false
  config.token_lifespan = 2.weeks
  config.batch_request_buffer_throttle = 5.seconds
  config.default_confirm_success_url = ENV["DEFAULT_CONFIRM_SUCCESS_URL"]
end

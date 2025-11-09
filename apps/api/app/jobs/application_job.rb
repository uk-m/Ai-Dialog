class ApplicationJob < ActiveJob::Base
  queue_as :default
  retry_on ActiveRecord::Deadlocked, wait: :exponentially_longer, attempts: 3
end

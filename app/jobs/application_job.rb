class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # Global error handling for all background jobs
    rescue_from StandardError do |exception|
      # Log the exception
      ExceptionHandler.capture_exception(exception,
                                         job_class: self.class.name,
                                         job_id: job_id,
                                         arguments: arguments)
    end
end

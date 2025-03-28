class ExceptionHandler
  def self.capture_exception(exception, context = {})
    Rails.logger.error "Exception: #{exception.class.name}"
    Rails.logger.error "Message: #{exception.message}"
    Rails.logger.error "Backtrace:\n#{exception.backtrace&.join("\n")}"
  end
end

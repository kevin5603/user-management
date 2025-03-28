class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Global rescue for all controllers
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from StandardError, with: :handle_unexpected_error

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access Denied: #{exception.message}"
    respond_to do |format|
      format.html { render "errors/unauthorized", status: :forbidden }
      format.json { render json: { error: "You are not authorized to access this page." }, status: :forbidden }
    end
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :job_title, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :job_title, :phone_number])
  end

  def handle_record_not_found(exception)
    ExceptionHandler.capture_exception(exception)

    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", status: :not_found }
      format.json { render json: { error: "Record not found" }, status: :not_found }
    end
  end

  def handle_parameter_missing(exception)
    ExceptionHandler.capture_exception(exception)

    render json: { error: exception.message }, status: :bad_request
  end

  def handle_unexpected_error(exception)
    ExceptionHandler.capture_exception(exception)

    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/500.html", status: :internal_server_error }
      format.json { render json: { error: "Internal server error" }, status: :internal_server_error }
    end
  end
end

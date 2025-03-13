class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access Denied: #{exception.message}"
    respond_to do |format|
      format.html { render "errors/unauthorized", status: :forbidden }
      format.json { render json: { error: "You are not authorized to access this page." }, status: :forbidden }
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :job_title, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :job_title, :phone_number])
  end
end

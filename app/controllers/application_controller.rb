class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization unless: :devise_controller?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to access_denied_path, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone_number job_title])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name phone_number job_title])
  end
end

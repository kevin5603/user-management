class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name, :phone_number, :job_title])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :first_name, :last_name, :phone_number, :job_title])
  end
end

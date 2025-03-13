class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied, ActiveModel::ForbiddenAttributesError do | exception |
    flash[:error] = "You are not authorized to perform this action"
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :job_title])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :job_title])
  end
end

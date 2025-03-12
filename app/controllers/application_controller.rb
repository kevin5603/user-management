class ApplicationController < ActionController::Base
  include DeviseCustomParams
  before_action :check_email_confirmed, if: -> { user_signed_in? && !Rails.env.test? }

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access Denied: #{exception.message}"
    respond_to do |format|
      format.html { render "errors/unauthorized", status: :forbidden }
      format.json { render json: { error: "You are not authorized to access this page." }, status: :forbidden }
    end
  end

  private

  def check_email_confirmed
    if current_user && !current_user.confirmed?
      sign_out current_user
      redirect_to new_user_session_path, alert: "You must confirm your email before logging in."
    end
  end
end

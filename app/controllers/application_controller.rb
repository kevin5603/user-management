class ApplicationController < ActionController::Base
  include DeviseCustomParams
  before_action :check_email_confirmed, if: -> { user_signed_in? && !Rails.env.test? }

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { render "errors/unauthorized", status: :forbidden }  # Show a custom page
      format.json { render json: { error: "You are not authorized to access this page." }, status: :forbidden }
    end

    Rails.logger.error "Access Denied: #{exception.message}"
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end

  private

  def check_email_confirmed
    if current_user && !current_user.confirmed?
      sign_out current_user
      redirect_to new_user_session_path, alert: "You must confirm your email before logging in."
    end
  end
end

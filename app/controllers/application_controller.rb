class ApplicationController < ActionController::Base
  include DeviseCustomParams
  before_action :check_email_confirmed, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
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

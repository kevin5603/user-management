class ApplicationController < ActionController::Base
  include DeviseCustomParams
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end
end

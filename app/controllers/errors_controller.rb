class ErrorsController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  def access_denied
    @previous_url = request.referer
  end
end